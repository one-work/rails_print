module Print
  module Model::MqttPrinter
    extend ActiveSupport::Concern
    PREFIX = [0x1e, 0x10]
    TAG = [0x1b, 0x63]

    included do
      attribute :dev_imei, :string, index: true
      attribute :dev_type, :string
      attribute :dev_vendor, :string
      attribute :dev_network, :string
      attribute :dev_tel, :string
      attribute :dev_spec, :string
      attribute :dev_cut, :boolean
      attribute :dev_desc, :string
      attribute :dev_ip, :string
      attribute :online, :boolean
      attribute :username, :string
      attribute :password, :string
      attribute :extra, :json, default: {}

      belongs_to :organ, class_name: 'Org::Organ', optional: true

      has_one :mqtt_user, primary_key: :username, foreign_key: :username, dependent: :destroy

      has_many :devices, as: :printer
      accepts_nested_attributes_for :devices

      before_validation :init_username, if: :dev_imei_changed?
      after_save :init_mqtt_user, if: :saved_change_to_username?
    end

    def init_username
      r = Digest::MD5.hexdigest("linlishenghuo-#{dev_imei}").upcase
      self.username = r[0..11]
      self.password = r[-16..-1]
    end

    def init_mqtt_user
      mqtt_user || build_mqtt_user
      mqtt_user.set_pass(password)
      mqtt_user.save
    end

    def assign_info(payload)
      infos = payload.split('#')

      self.extra = {
        '终端类型' => infos[0],
        '注册期限' => infos[3],
        '方案提供商编号' => infos[4],
        '方案编号' => infos[6],
        '版本序号' => infos[7],
        '版本描述' => infos[8]
      }
      self.dev_vendor = infos[2]
      self.dev_network = infos[5]
      self.dev_tel = infos[9]
      self.dev_spec = infos[10]
      self.dev_cut = infos[11]
    end

    def api
      return @api if defined? @api
      @api = EmqxApi.new
    end

    def register_success
      api.publish "#{dev_imei}/unregistered", 'registerSuccess'
    end

    def register_401
      api.publish "#{dev_imei}/unregistered", 'registerFail@401'
    end

    def confirm(payload, kind: 'ready')
      _, id = payload.split('#')
      api.publish "#{dev_imei}/confirm", "#{kind}##{id}"
    end

    def confirm_complete(payload)
      _, task_id = payload.split('#')
      task = Task.find task_id
      task.update completed_at: Time.current

      api.publish "#{dev_imei}/confirm", "complete##{task_id}"
    end

    def print(task_id)
      pr = BaseEsc.new
      yield pr

      print_cmd(pr.render, task_id)
      pr
    end

    def print_cmd(payload, task_id)
      task_bytes = task_id.bytes
      task_size = task_bytes.size
      payload_bytes = payload
      payload_size = [payload_bytes.size].pack('N').bytes
      x = Crc16Util.check(payload_bytes.map(&:to_16_str))
      check = [x].pack('n').bytes

      all = [task_size] + task_bytes + payload_size + payload_bytes + TAG + check
      all_size = [all.size].pack('N').bytes

      r = (PREFIX + all_size + all)
      api.publish dev_imei, Base64.encode64(r.pack('C*')), payload_encoding: 'base64'
    end

  end
end

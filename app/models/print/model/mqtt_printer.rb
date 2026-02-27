module Print
  module Model::MqttPrinter
    extend ActiveSupport::Concern
    PREFIX = [0x1e, 0x10]
    TAG = [0x1b, 0x63]
    VOICE = [0x1b, 0x23, 0x23, 0x50, 0x4c, 0x4d, 0x43]
    CLEAR_USER = [0x1f, 0x28, 0x75, 0x02, 0x00, 0x43, 0x55]

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

      has_many :devices, as: :printer, dependent: :delete_all
      accepts_nested_attributes_for :devices, allow_destroy: true
      has_many :tasks, through: :devices
      has_many :template_tasks
      has_many :raw_tasks

      before_validation :init_username, if: :dev_imei_changed?
      after_save :init_mqtt_user, if: :saved_change_to_username?
      after_save :clear_devices, if: -> { saved_change_to_organ_id? && organ_id.blank? }
    end

    def init_username
      r = Digest::MD5.hexdigest("linlishenghuo-#{dev_imei}").upcase
      self.username = r[0..11]
      self.password = r[-16..-1]
    end

    def clear_devices
      devices.delete_all
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
      api.publish(
        "#{dev_imei}/unregistered",
        'registerSuccess'
      )
    end

    def register_success_with_user
      api.publish(
        "#{dev_imei}/unregistered",
        "registerSuccess@#{username}@#{password}"
      )
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
      task = Task.find_by id: task_id
      task.update completed_at: Time.current if task

      api.publish "#{dev_imei}/confirm", "complete##{task_id}"
    end

    def print(task)
      pr = BaseEsc.new
      yield pr
      task.body = pr.render_raw
      task.save

      print_cmd(pr.render, task.id)
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
      cmd(r)
    end

    def voice(type = 0xc1)
      payload = VOICE + [type]
      print_cmd(payload, '1001')
    end

    def clear_user
      cmd(CLEAR_USER.map(&:to_16_str))
    end

    def test_print
      cmd([0x12, 0x54].map(&:to_16_str))
    end

    def cmd(r)
      api.publish dev_imei, Base64.encode64(r.pack('C*')), payload_encoding: 'base64'
    end

    def dev_qrcode
      QrcodeUtil.data_url(dev_imei)
    end

    def webhook_url
      Rails.app.routes.url_for(
        controller: 'print/api/tasks',
        action: 'create',
        mqtt_printer_id: id
      )
    end

  end
end

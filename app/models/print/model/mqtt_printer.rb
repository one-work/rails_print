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

      has_one :mqtt_user, primary_key: :username, foreign_key: :username, dependent: :destroy

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
      @api = $mqtt_user.api
    end

    def register_success
      api.publish "#{dev_imei}/unregistered", 'registerSuccess', false, 2
    end

    def register_401
      api.publish "#{dev_imei}/unregistered", 'registerFail@401', false, 2
    end

    def confirm(payload, kind: 'ready')
      _, id = payload.split('#')
      api.publish "#{dev_imei}/confirm", "#{kind}##{id}", false, 2
    end

    def print
      pr = BaseEsc.new
      esc = yield pr

      payload = esc.render
      print_cmd(payload)
    end

    def print_cmd(payload, task: '1001')
      task_bytes = task.bytes
      task_size = task_bytes.size
      payload_bytes = payload
      payload_size = [payload_bytes.size].pack('N').bytes
      x = Crc16Util.check(payload_bytes.map(&:to_16_str))
      check = [x].pack('n').bytes

      all = [task_size] + task_bytes + payload_size + payload_bytes + TAG + check
      all_size = [all.size].pack('N').bytes

      r = (PREFIX + all_size + all)
      logger.debug "The Str: #{r}"

      api.publish dev_imei, r.pack('C*'), false, 2
      r
    end

  end
end

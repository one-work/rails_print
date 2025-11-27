module Print
  module Model::JiaBoPrinter
    extend ActiveSupport::Concern
    BASE = 'https://api.poscom.cn/apisc/'
    PRINT = {
      '22' => 'TSPL',
      '11' => 'ESC'
    }

    included do
      attribute :device_id, :string
      attribute :dev_name, :string
      attribute :grp_id, :string
      attribute :dev_id, :string
      attribute :online, :boolean

      belongs_to :organ, class_name: 'Org::Organ', optional: true

      belongs_to :jia_bo_app, counter_cache: true
      has_many :devices, as: :printer, dependent: :delete_all

      accepts_nested_attributes_for :devices

      enum :cmd_type, {
        esc: 'ESC',
        tspl: 'TSPL'
      }, prefix: true

      after_create_commit :add_to_jia_bo
    end

    def print
      pr = BaseEsc.new
      yield pr

      remote_print(
        data: pr.render_raw,
        mode: 3,
        cmd_type: 'ESC'
      )
    end

    def remote_print(msg_no: nil, data: nil, mode: 2, cmd_type: 'TSPL', reprint: 0, multi: 0)
      msg_api = JiaBo::DeviceMsgApi.new(self)
      params = {
        mode: mode,
        charset: 1,
        cmdType: cmd_type,
        msgDetail: data,
        reprint: reprint,
        multi: multi
      }
      params.merge! msgNo: msg_no if msg_no.present?

      r = msg_api.msg params
      logger.debug "\e[35m  #{r}  \e[0m"
      r
    end

    def update_status!
      r = get_status
      self.online = r['online']
      self.cmd_type = PRINT[info['printType']]
      self.save
    end

    def get_status
      r = jia_bo_app.api.get_status(device_id)
      r['code'] == 1 ? r['statusList'][0] : r
    end

    # 取值范围 0-100，建议(0, 25, 50, 75, 85, 100)。
    def send_volume(level = 20)
      api.send_volume level
    end

    def info
      api_new = JiaBo::DeviceNewApi.new(self)
      r = api_new.info
      r['code'] == 0 ? r['msg'] : r
    end

    def cancel_print
      api.cancel_print(all: 1)
    end

    def add_to_jia_bo
      result = api.add_dev devName: id
      self.update dev_id: result['devID'] if result['code'] == 1
      result
    end

    def remove_from_jia_bo
      r = api.del_dev
      if r['code'] == 1
        self.update dev_id: nil
      end
    end

    def approved?
      dev_id.present?
    end

    def api
      return @api if defined? @api
      @api = JiaBo::DeviceApi.new(self)
    end

  end
end

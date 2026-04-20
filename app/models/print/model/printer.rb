module Print
  module Model::Printer
    extend ActiveSupport::Concern
    PREFIX = [0x1e, 0x10]
    TAG = [0x1b, 0x63]
    VOICE = [0x1b, 0x23, 0x23, 0x50, 0x4c, 0x4d, 0x43]
    CLEAR_USER = [0x1f, 0x28, 0x75, 0x02, 0x00, 0x43, 0x55]
    TYPE = [0x1f, 0x2d, 0x4d, 0x01]

    included do
      attribute :type, :string
      attribute :name, :string
      attribute :dev_imei, :string, index: true
      attribute :dev_vendor, :string
      attribute :dev_tel, :string
      attribute :dev_spec, :string
      attribute :dev_cut, :boolean
      attribute :dev_desc, :string
      attribute :dev_version, :string
      attribute :dev_type, :integer
      attribute :dev_cut_type, :integer
      attribute :extra, :json, default: {}

      enum :dev_type, {
        cpcl: 1,
        esc: 2
      }, default: 'cpcl', prefix: true

      enum :dev_cut_type, {
        full: 0,
        partial: 1
      }, default: 'full', prefix: true

      has_many :printer_organs, dependent: :delete_all
      accepts_nested_attributes_for :printer_organs, allow_destroy: true

      has_many :tasks, dependent: :delete_all
      has_many :template_tasks, dependent: :delete_all
      has_many :raw_tasks, dependent: :delete_all
      has_many :deferred_tasks, dependent: :delete_all
      has_many :inner_tasks, dependent: :delete_all

      validates :name, uniqueness: { scope: :organ_id }

      after_save :clear_devices, if: -> { saved_change_to_organ_id? && organ_id.blank? }
      after_save_commit :check_undo_tasks, if: -> { online && (saved_changes.keys & ['online', 'ready_at']).present? }
      after_save_commit :set_dev_type, if: -> { saved_change_to_dev_type? }
    end

    def clear_devices
      devices.delete_all
    end

    def assign_info(payload)
      infos = payload.split('#')

      self.extra = {
        '终端类型' => infos[0],
        '注册期限' => infos[3],
        '方案提供商编号' => infos[4],
        '方案编号' => infos[6]
      }
      self.dev_version = infos[7]
      self.dev_desc = infos[8]
      self.dev_vendor = infos[2]
      self.dev_network = infos[5]
      self.dev_tel = infos[9]
      self.dev_spec = infos[10]
      self.dev_cut = infos[11]
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

    def set_dev_type
      set_raw_test! text: '', arr: TYPE + [dev_type_before_type_cast]
    end

    def download_os(url = 'http://images.one.work/printer/printer_os_260312.bin')
      arr = [0x1f, 0x28, 0x75]
      size = url.bytes.size + 2
      arr.push size % 256, (size / 256.0).floor
      arr.push 0x55, 0x48
      arr.concat url.bytes

      set_raw_test!(text: url, arr: arr)
    end

    def set_deferred_task(text)
      task = deferred_tasks.build(note: text)
      task.set_esc do |pr|
        pr.text_big_center text
        pr.break_line
        pr.qrcode_center dev_imei
      end
      task
    end

    def set_deferred_task!(text)
      task = set_deferred_task(text)
      task.save
    end

    def set_deferred_test(text = '自测页')
      task = deferred_tasks.build(note: text)
      task.set_raw_array([0x12, 0x54])
    end

    def set_raw_task(text)
      task = raw_tasks.build(note: text)
      task.set_esc do |pr|
        pr.text_big_center text
        pr.break_line
        pr.qrcode_center dev_imei
      end
    end

    def set_raw_task!(text)
      task = set_raw_task(text)
      task.save
    end

    def set_raw_test(text:, arr:)
      raw_task = raw_tasks.build(note: text)
      raw_task.set_raw_array arr
      raw_task
    end

    def set_raw_test!(text:, arr:)
      task = set_raw_test(text: text, arr: arr)
      task.save
    end

    def check_undo_tasks
      tasks.todo.map do |task|
        r = task.print
        logger.debug r
      end
    end

    def test_print(type = nil)
      task = raw_tasks.build

      case type
      when 'text'
        task.note = '文字测试'
        task.set_esc! { |pr| pr.text '文字打印' }
      when 'qrcode'
        task.note = '二维码测试'
        task.set_esc! { |pr| pr.qrcode_center dev_imei }
      when 'bar'
        task.note = '条码测试'
        task.set_esc! { |pr| pr.barcode dev_imei }
      when 'image'
        task.set_raw_array!(test_image_data)
      else
        task.set_raw_array!([0x12, 0x54])
      end
    end

    def dev_qrcode
      QrcodeUtil.data_url(dev_imei)
    end

    def webhook_url(action: 'create')
      Rails.app.routes.url_for(
        controller: 'print/api/tasks',
        action: action,
        printer_id: id
      )
    end

  end
end

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
      attribute :dev_version, :string
      attribute :dev_ip, :string
      attribute :online, :boolean
      attribute :registered_at, :datetime
      attribute :authorized_at, :datetime
      attribute :ready_at, :datetime
      attribute :username, :string
      attribute :password, :string
      attribute :extra, :json, default: {}

      belongs_to :organ, class_name: 'Org::Organ', optional: true

      has_one :mqtt_user, primary_key: :username, foreign_key: :username, dependent: :destroy

      has_many :devices, as: :printer, dependent: :delete_all
      accepts_nested_attributes_for :devices, allow_destroy: true

      has_many :tasks, primary_key: :dev_imei, foreign_key: :imei
      has_many :template_tasks, primary_key: :dev_imei, foreign_key: :imei
      has_many :raw_tasks, primary_key: :dev_imei, foreign_key: :imei
      has_many :deferred_tasks, primary_key: :dev_imei, foreign_key: :imei

      before_validation :init_username, if: :dev_imei_changed?
      before_save :sync_online, if: -> { ready_at_changed? && ready_at.present? && authorized_at.present? }
      after_save :init_mqtt_user, if: -> { (saved_changes.keys & ['registered_at', 'username']).present? && registered_at.present? }
      after_save :clear_devices, if: -> { saved_change_to_organ_id? && organ_id.blank? }

      after_save_commit :check_undo_tasks, if: -> { online && saved_change_to_online? }
    end

    def init_username
      r = Digest::MD5.hexdigest("linlishenghuo-#{dev_imei}").upcase
      self.username = r[0..11]
      self.password = r[-16..-1]
    end

    def clear_devices
      devices.delete_all
    end

    def sync_online
      if ready_at > authorized_at
        self.online = true
      end
    end

    def authorized!
      self.update authorized_at: Time.current
      set_deferred_task!('欢迎使用打印机!')
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

    def api
      return @api if defined? @api
      @api = EmqxApi
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

      if ready_at.blank?
        set_deferred_task!('密码设置成功!')
        set_deferred_test
      end
    end

    def register_401
      api.publish "#{dev_imei}/unregistered", 'registerFail@401'
    end

    def confirm_exception(payload)
      _, id = payload.split('#')
      api.publish "#{dev_imei}/confirm", "exception##{id}"

      self.update online: false
    end

    def confirm_ready!(payload)
      items = payload.split('#')
      api.publish "#{dev_imei}/confirm", "ready##{items[1]}"

      # 数据库不存在记录，则清除账号密码后触发重设
      if new_record?
        clear_user
      else

      end
      self.ready_at = Time.current
      self.dev_version = items[2] if items[2].present? # 第三位如果存在，则为版本号
      self.save
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
      task.raw = pr.render
      task.save

      print_cmd(task.raw, task.id)
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
      raw_task = RawTask.new(imei: dev_imei)
      raw_task.set_raw_array! CLEAR_USER

      set_deferred_task!('密码重置成功!')
      set_deferred_test
    end

    def download_os(url = 'http://images.one.work/printer/printer_os_260312.bin')
      task = RawTask.new(imei: dev_imei, note: url)
      arr = [0x1f, 0x28, 0x75]
      size = url.bytes.size + 2
      arr.push size % 256, (size / 256.0).floor
      arr.push 0x55, 0x48
      arr.concat url.bytes

      task.set_raw_array!(arr)
    end

    def set_deferred_task!(text)
      task = DeferredTask.new(imei: dev_imei, note: text)
      task.set_esc! do |pr|
        pr.set_pad
        pr.text_big_center text
        pr.qrcode dev_imei
      end
    end

    def set_raw_task!(text)
      task = RawTask.new(imei: dev_imei, note: text)
      task.set_esc! do |pr|
        pr.set_pad
        pr.text text
        pr.qrcode dev_imei
      end
    end

    def check_undo_tasks
      tasks.todo.map do |task|
        r = task.print
        logger.debug r
      end
    end

    def set_deferred_test
      task = DeferredTask.new(imei: dev_imei, note: '自测页')
      task.set_raw_array!([0x12, 0x54])
    end

    def test_print(type = nil)
      task = RawTask.new(imei: dev_imei, note: '测试')

      case type
      when 'text'
        task.set_esc! { |pr| pr.text '文字打印' }
      when 'qrcode'
        task.set_esc! { |pr| pr.qrcode dev_imei }
      when 'bar'
        task.set_esc! { |pr| pr.barcode dev_imei }
      when 'image'
        task.set_raw_array!(test_image_data)
      else
        task.set_raw_array!([0x12, 0x54])
      end
    end

    def test_image_data
      hex = Rails.root.join('public/100.txt').read.delete("\t\r\n")
      hex.split(' ').map { |i| i.to_i(16) }
    end

    def cmd_plain(r)
      api.publish dev_imei, r
    end

    def cmd(r)
      api.publish dev_imei, Base64.encode64(r.pack('C*')), payload_encoding: 'base64'
    end

    def dev_qrcode
      QrcodeUtil.data_url(dev_imei)
    end

    def register_url
      Rails.app.routes.url_for(
        controller: 'print/admin/mqtt_printers',
        action: 'bind',
        dev_imei: dev_imei,
        host: "admin.#{Rails.app.routes.default_url_options[:host]}"
      )
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

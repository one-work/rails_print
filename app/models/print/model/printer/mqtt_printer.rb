module Print
  module Model::Printer::MqttPrinter
    extend ActiveSupport::Concern

    included do
      attribute :dev_network, :string
      attribute :dev_ip, :string
      attribute :online, :boolean
      attribute :registered_at, :datetime
      attribute :authorized_at, :datetime
      attribute :ready_at, :datetime
      attribute :offline_at, :datetime
      attribute :username, :string
      attribute :password, :string

      has_one :mqtt_user, primary_key: :username, foreign_key: :username, dependent: :destroy

      before_validation :init_username, if: :dev_imei_changed?
      before_save :sync_online, if: -> { ready_at_changed? && ready_at.present? && authorized_at.present? }
      after_save :init_mqtt_user, if: -> { (saved_changes.keys & ['registered_at', 'username']).present? && registered_at.present? }
    end

    def init_username
      r = Digest::MD5.hexdigest("linlishenghuo-#{dev_imei}").upcase
      self.username = r[0..11]
      self.password = r[-16..-1]
    end

    def sync_online
      if ready_at > authorized_at
        self.online = true
        self.offline_at = nil
      end
    end

    def authorized!
      self.update authorized_at: Time.current
    end

    def init_mqtt_user
      mqtt_user || build_mqtt_user
      mqtt_user.set_pass(password)
      mqtt_user.save
    end

    def api
      return @api if defined? @api
      @api = EmqxApi
    end

    def confirm_exception(payload)
      _, id = payload.split('#')
      api.publish "#{dev_imei}/confirm", "exception##{id}"

      self.update online: false, offline_at: Time.current
    end

    def confirm_ready!(payload)
      items = payload.split('#')
      api.publish "#{dev_imei}/confirm", "ready##{items[1]}"

      # 数据库不存在记录，则清除账号密码后触发重设
      if new_record?
        set_raw_test(text: '清除', arr: CLEAR_USER)

        set_deferred_task('密码重置成功!')
        set_deferred_test
      else
        set_deferred_task('欢迎使用打印机!')
      end
      self.ready_at = Time.current
      self.dev_version = items[2] if items[2].present? # 第三位如果存在，则为版本号
      self.save
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

    def confirm_complete(payload)
      _, task_id = payload.split('#')
      task = Task.find_by id: task_id
      task.update completed_at: Time.current if task
      api.publish "#{dev_imei}/confirm", "complete##{task_id}"
    end

    def register_401
      api.publish "#{dev_imei}/unregistered", 'registerFail@401'
    end

    def cmd_plain(r)
      api.publish dev_imei, r
    end

    def cmd(r)
      api.publish dev_imei, Base64.encode64(r.pack('C*')), payload_encoding: 'base64'
    end

    def register_url
      Rails.app.routes.url_for(
        controller: 'print/admin/mqtt_printers',
        action: 'bind',
        dev_imei: dev_imei,
        host: "admin.#{Rails.app.routes.default_url_options[:host]}"
      )
    end

  end
end

module Print
  class HomeController < BaseController
    skip_before_action :verify_authenticity_token, only: [:message, :ready, :exception, :complete]
    before_action :set_mqtt_printer, only: [:ready, :exception]

    def message
      @mqtt_printer = MqttPrinter.find_or_initialize_by(dev_imei: params[:clientid])
      @mqtt_printer.dev_ip = params[:peerhost]
      @mqtt_printer.assign_info(params[:payload])
      @mqtt_printer.save

      if params[:peerhost]
        @mqtt_printer.register_success_with_user
      else
        @mqtt_printer.register_success
      end

      head :ok
    end

    # cloudPrinter/ready
    def ready
      @mqtt_printer.confirm(params[:payload], kind: 'ready')
      if @mqtt_printer.new_record?
        # 数据库不存在记录，则清除账号密码后触发重设
        @mqtt_printer.clear_user
      end

      head :ok
    end

    # cloudPrinter/exception
    def exception
      @mqtt_printer.confirm(params[:payload], kind: 'exception')

      head :ok
    end

    # cloudPrinter/complete
    def complete
      dev_imei, task_id = payload.split('#')
      task = Task.find_by id: task_id
      task.update completed_at: Time.current if task
      EmqxApi.publish "#{dev_imei}/confirm", "complete##{task_id}"

      head :ok
    end

    private
    def set_mqtt_printer
      @mqtt_printer = MqttPrinter.find_or_initialize_by(dev_imei: params[:clientid])
    end

  end
end

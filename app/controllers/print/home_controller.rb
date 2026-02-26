module Print
  class HomeController < BaseController
    skip_before_action :verify_authenticity_token, only: [:message, :ready, :exception, :complete]
    before_action :set_mqtt_printer, only: [:ready, :exception, :complete]

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

      head :ok
    end

    # cloudPrinter/exception
    def exception
      @mqtt_printer.confirm(params[:payload], kind: 'exception')

      head :ok
    end

    # cloudPrinter/complete
    def complete
      @mqtt_printer.confirm_complete(params[:payload])

      head :ok
    end

    private
    def set_mqtt_printer
      @mqtt_printer = MqttPrinter.find_by(dev_imei: params[:clientid])
    end

  end
end

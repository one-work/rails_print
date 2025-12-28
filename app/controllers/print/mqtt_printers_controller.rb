module Print
  class MqttPrintersController < BaseController
    before_action :set_mqtt_printer, only: [:print]

    def print
      @mqtt_printer.print()
      render json: { devices: @devices.pluck(:name) }
    end

    private
    def set_mqtt_printer
      @mqtt_printer = MqttPrinter.find(params[:id])
    end

  end
end

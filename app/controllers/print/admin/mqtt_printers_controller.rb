module Print
  class Admin::MqttPrintersController < Admin::BaseController
    before_action :set_mqtt_printer, only: [:show, :edit, :update, :destroy, :actions]

    def index
      @mqtt_printers = MqttPrinter.default_where(default_params).page(params[:page])
    end

    def test
      @mqtt_printer.test_print
    end

    def new
      @mqtt_printer.devices.build
    end

    def edit
      @mqtt_printer.devices.presence || @mqtt_printer.devices.build
    end

    def destroy
      @mqtt_printer.organ_id = nil
      @mqtt_printer.save
    end

    private
    def set_mqtt_printer
      @mqtt_printer = MqttPrinter.find params[:id]
    end

    def set_new_mqtt_printer
      @mqtt_printer = MqttPrinter.new(printer_params)
    end

    def mqtt_printer_params
      params.fetch(:mqtt_printer, {}).permit(
        devices_attributes: [:aim]
      )
    end

  end
end

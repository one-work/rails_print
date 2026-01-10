module Print
  class Admin::MqttPrintersController < Admin::BaseController
    before_action :set_mqtt_printer, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_mqtt_printer, only: [:new]

    def index
      @mqtt_printers = MqttPrinter.default_where(default_params).page(params[:page])
    end

    def test
      @mqtt_printer.test_print
    end

    def create
      @mqtt_printer = MqttPrinter.find_by(dev_imei: params[:dev_imei])

      if @mqtt_printer
        @mqtt_printer.organ = current_organ
        @mqtt_printer.devices.find_or_initialize_by(aim: 'produce')
        @mqtt_printer.devices.find_or_initialize_by(aim: 'receipt')
        @mqtt_printer.save!
      else
        @mqtt_printer = MqttPrinter.new
        @mqtt_printer.errors.add :base, '该打印机未注册'
        render :new, locals: { model: @mqtt_printer }, status: :unprocessable_entity
      end
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
      @mqtt_printer = MqttPrinter.new
    end

    def mqtt_printer_params
      params.fetch(:mqtt_printer, {}).permit(
        devices_attributes: [:aim]
      )
    end

  end
end

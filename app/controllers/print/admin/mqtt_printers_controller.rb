module Print
  class Admin::MqttPrintersController < Admin::BaseController
    before_action :set_mqtt_printer, only: [:show, :edit, :update, :destroy, :actions, :test_print]
    before_action :set_new_mqtt_printer, only: [:new]

    def index
      @mqtt_printers = MqttPrinter.includes(:printer_organs).where(printer_organs: { organ_id: current_organ.id }).page(params[:page])
    end

    def test_print
      @mqtt_printer.test_print(params[:type])
    end

    def bind
      @mqtt_printer = MqttPrinter.find_by(dev_imei: params[:dev_imei])
    end

    def scan
      @mqtt_printer = MqttPrinter.find_by(dev_imei: params[:result])

      if @mqtt_printer
        mqtt_printer = MqttPrinter.find_by(dev_imei: params[:result])
        mqtt_printer.organ = current_organ
        mqtt_printer.printer_organs.find_or_initialize_by(aim: 'produce')
        mqtt_printer.printer_organs.find_or_initialize_by(aim: 'receipt')
        mqtt_printer.save!
      else
        @mqtt_printer = MqttPrinter.new
        @mqtt_printer.errors.add :base, '该打印机未注册'
        render :new, locals: { model: @mqtt_printer }, status: :unprocessable_entity
      end
    end

    def create
      @mqtt_printer = MqttPrinter.find_by(dev_imei: params[:dev_imei])

      if @mqtt_printer
        @mqtt_printer.organ = current_organ
        @mqtt_printer.printer_organs.find_or_initialize_by(aim: 'produce')
        @mqtt_printer.printer_organs.find_or_initialize_by(aim: 'receipt')
        @mqtt_printer.save!
      else
        @mqtt_printer = MqttPrinter.new
        @mqtt_printer.errors.add :base, '该打印机未注册'
        render :new, locals: { model: @mqtt_printer }, status: :unprocessable_entity
      end
    end

    def edit
      @mqtt_printer.printer_aims.build
    end

    def destroy
      @printer_organ = nil
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
        :dev_type,
        :dev_cut_type,
        printer_aims_attributes: [:aim, :id, :_destroy]
      )
    end

  end
end

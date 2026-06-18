module Print
  class Admin::BluetoothPrintersController < Admin::BaseController
    before_action :set_bluetooth_printer, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_bluetooth_printer, only: [:new, :create]

    def index
      @bluetooth_printers = BluetoothPrinter.includes(:printer_aims).where(printer_aims: { organ_id: current_organ.id }).page(params[:page])
    end

    def scan
      if params[:result].include?('&')
        name, _ = params[:result].split('&')

        @bluetooth_printer = BluetoothPrinter.find_or_create_by(name: name)
        @bluetooth_printer.save
      end

      @bluetooth_printer.printer_aims.find_or_initialize_by(**default_form_params)
      @bluetooth_printer.save!
    end

    def edit
      if @bluetooth_printer.printer_aims.none?
        @bluetooth_printer.printer_aims.build(organ_id: current_organ.id)
      end
    end

    private
    def set_bluetooth_printer
      @bluetooth_printer = BluetoothPrinter.find(params[:id])
    end

    def set_new_bluetooth_printer
      @bluetooth_printer = BluetoothPrinter.new(bluetooth_printer_params)
      @bluetooth_printer.printer_aims.build(organ_id: current_organ.id)
    end

    def bluetooth_printer_params
      params.fetch(:bluetooth_printer, {}).permit(
        :name,
        :dev_type,
        printer_aims_attributes: [:aim, :organ_id, :id, :_destroy]
      )
    end

  end
end

module Print
  class Admin::BluetoothPrintersController < Admin::BaseController
    before_action :set_bluetooth_printer, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_bluetooth_printer, only: [:new, :create]

    def index
      @bluetooth_printers = BluetoothPrinter.includes(:printer_organs).where(printer_organs: { organ_id: current_organ.id }).page(params[:page])
    end

    def edit
      @bluetooth_printer.printer_aims.build if @bluetooth_printer.printer_aims.none?
    end

    private
    def set_bluetooth_printer
      @bluetooth_printer = BluetoothPrinter.find(params[:id])
    end

    def set_new_bluetooth_printer
      @bluetooth_printer = BluetoothPrinter.new(bluetooth_printer_params)
      @bluetooth_printer.printer_organs.build(organ_id: current_organ.id)
    end

    def bluetooth_printer_params
      params.fetch(:bluetooth_printer, {}).permit(
        :name,
        :dev_type,
        printer_aims_attributes: [:aim, :id, :_destroy]
      )
    end

  end
end

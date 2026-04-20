module Print
  class Admin::BluetoothPrintersController < Admin::BaseController
    before_action :set_bluetooth_printer, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_bluetooth_printer, only: [:new, :create]

    def edit
      ['produce', 'receipt', 'demo'].each do |aim|
        @bluetooth_printer.devices.load.find { |i| i.aim == aim } || @bluetooth_printer.devices.build(aim: aim)
      end
    end

    private
    def set_bluetooth_printer
      @bluetooth_printer = BluetoothPrinter.find(params[:id])
    end

    def set_new_bluetooth_printer
      @bluetooth_printer = BluetoothPrinter.new(bluetooth_printer_params)
    end

    def bluetooth_printer_params
      p = params.fetch(:bluetooth_printer, {}).permit(
        :name,
        devices_attributes: [:aim, :id, :_destroy]
      )
      p.merge! default_params
    end

  end
end

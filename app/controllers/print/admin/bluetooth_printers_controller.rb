module Print
  class Admin::BluetoothPrintersController < Admin::BaseController
    before_action :set_new_bluetooth_printer, only: [:new, :create]

    private
    def set_new_bluetooth_printer
      @bluetooth_printer = BluetoothPrinter.new(bluetooth_printer_params)
    end

    def bluetooth_printer_params
      p = params.fetch(:bluetooth_printer, {}).permit(
        :name
      )
      p.merge! default_params
    end

  end
end

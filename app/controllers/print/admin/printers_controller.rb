module Print
  class Admin::PrintersController < Admin::BaseController
    before_action :set_printer, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_printer, only: [:new, :create]

    def index
      @printers = Printer.default_where(default_params).page(params[:page])
    end

    def test
      @printer.test_print
    end

    def new
      @printer.devices.build
    end

    def edit
      @printer.devices.presence || @printer.devices.build
    end

    private
    def set_printer
      @printer = Printer.find params[:id]
    end

    def set_new_printer
      @printer = Printer.new(printer_params)
    end

    def printer_params
      p = params.fetch(:printer, {}).permit(
        :uid,
        devices_attributes: [:aim]
      )
      p.merge! default_form_params
    end

  end
end

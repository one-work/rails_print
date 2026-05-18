module Print
  class Panel::PrinterAimsController < Panel::BaseController
    before_action :set_printer
    before_action :set_new_printer_aim, only: [:new, :create]

    def index
      @printer_aims = @printer.printer_aims.includes(:organ)
    end

    private
    def set_printer
      @printer = Printer.find params[:printer_id]
    end

    def set_new_printer_aim
      @printer_aim = @printer.printer_aims.build(printer_aim_params)
    end

    def printer_aim_params
      p = params.fetch(:printer_aim, {}).permit(
        :aim,
        :printer_id
      )
      p.merge! default_form_params
    end

  end
end

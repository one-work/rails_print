module Print
  class Admin::PrinterAimsController < Admin::BaseController
    before_action :set_device, only: [:show, :edit, :update, :destroy, :actions, :test]
    before_action :set_new_device, only: [:new, :create]

    def index
      @devices = current_organ.devices.includes(:printer)
    end

    private
    def set_device
      @device = Device.find params[:id]
    end

    def set_new_device
      @device = Device.new(device_params)
    end

    def device_params
      p = params.fetch(:device, {}).permit(
        :aim,
        :printer_type,
        :printer_id
      )
      p.merge! default_form_params
    end

  end
end

module Print
  class Admin::TasksController < Admin::BaseController
    before_action :set_device

    def index
      @tasks = @device.tasks.page(params[:page])
    end

    private
    def set_device
      @device = Device.find params[:device_id]
    end

  end
end

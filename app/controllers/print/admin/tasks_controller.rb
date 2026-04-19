module Print
  class Admin::TasksController < Admin::BaseController
    before_action :set_device
    before_action :set_new_task, only: [:new, :create]

    def index
      @tasks = @device.inner_tasks.order(id: :desc).page(params[:page])
    end

    private
    def set_device
      @device = Device.find params[:device_id]
    end

    def set_new_task
      @task = @device.printer.inner_tasks.build(task_params)
    end

    def task_params
      params.fetch(:task, {}).permit(
        :file
      )
    end

  end
end

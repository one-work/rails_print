module Print
  class Admin::TasksController < Admin::BaseController
    before_action :set_printer
    before_action :set_new_task, only: [:new, :create]

    def index
      @tasks = @printer.inner_tasks.order(id: :desc).page(params[:page])
    end

    private
    def set_printer
      @printer = Printer.find params[:printer_id]
    end

    def set_new_task
      @task = @printer.inner_tasks.build(task_params)
    end

    def task_params
      params.fetch(:task, {}).permit(
        :file
      )
    end

  end
end

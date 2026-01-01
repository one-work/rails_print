module Print
  class TasksController < BaseController
    before_action :set_printer
    before_action :set_new_task, only: [:create]

    def create
      @task.save

      render json: {  }
    end

    private
    def set_printer
      @printer = MqttPrinter.find(params[:printer_id])
    end

    def set_new_task
      @task = @printer.template_tasks.build(task_params)
    end

    def task_params
      params.permit(
        :body
      )
    end

  end
end

module Print
  class TasksController < BaseController
    before_action :set_printer
    before_action :set_new_task, only: [:create]

    def create
      @task.save

      render json: { task_id: @task.id }
    end

    private
    def set_printer
      @printer = MqttPrinter.find(params[:printer_id])
    end

    def set_new_task
      if params[:template_id]
        @task = @printer.template_tasks.build(task_params)
      else
        @task = @printer.raw_tasks.build(task_params)
      end
    end

    def task_params
      params.permit(
        :uid,
        :body,
        :template_id,
        :print_at
      )
    end

  end
end

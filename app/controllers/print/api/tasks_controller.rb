module Print
  class Api::TasksController < Api::BaseController
    before_action :set_printer
    before_action :set_new_task, only: [:create]

    def create
      @task = @printer.raw_tasks.build(task_params)
      @task.body = params[:body]
      @task.save

      render json: { task_id: @task.id }
    end

    def template
      @task = @printer.template_tasks.build(task_params)
      @task.template_id = params[:template_id]
      @task.payload = params.fetch(:payload, {}).permit!
      @task.save

      render json: { task_id: @task.id }
    end

    private
    def set_printer
      @printer = MqttPrinter.find(params[:mqtt_printer_id])
    end

    def task_params
      params.permit(
        :body,
        :uid,
        :print_at
      )
    end

  end
end

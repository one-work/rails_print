module Print
  class Api::TasksController < Api::BaseController
    before_action :set_printer

    def create
      @task = @printer.raw_tasks.build(task_params)
      @task.raw = params[:raw]
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

    def inner
      @task = @printer.inner_tasks.build(gid: params[:gid], aim: params[:aim])
      @task.save
    end

    private
    def set_printer
      @printer = MqttPrinter.find(params[:mqtt_printer_id])
    end

    def task_params
      params.permit(
        :raw,
        :uid,
        :template_id,
        :print_at,
        payload: {}
      )
    end

  end
end

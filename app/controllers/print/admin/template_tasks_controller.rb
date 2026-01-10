module Print
  class Admin::TemplateTasksController < Admin::BaseController
    before_action :set_template
    before_action :set_new_template_task, only: [:new, :create]
    before_action :set_mqtt_printers, only: [:new, :create, :edit, :update]

    def index
      @template_tasks = @template.template_tasks.order(id: :desc).page(params[:page])
    end

    private
    def set_template
      @template = Template.find params[:template_id]
    end

    def set_new_template_task
      @template_task = @template.template_tasks.build(template_task_params)
    end

    def set_mqtt_printers
      @mqtt_printers = MqttPrinter.default_where(default_params)
    end

    def template_task_params
      params.fetch(:template_task, {}).permit(
        :mqtt_printer_id,
        payload: {}
      )
    end

  end
end

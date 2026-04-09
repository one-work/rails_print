module Print
  class Admin::Printer::TemplateTasksController < Admin::TemplateTasksController
    before_action :set_mqtt_printer
    before_action :set_new_template_task, only: [:new, :create]

    private
    def set_mqtt_printer
      @mqtt_printer = MqttPrinter.find params[:mqtt_printer_id]
    end

    def set_new_template_task
      @template_task = @template.template_tasks.build(template_task_params)
      @template_task.imei = @mqtt_printer.dev_imei
    end

  end
end

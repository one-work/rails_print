module Print
  class Panel::TasksController < Panel::BaseController
    before_action :set_mqtt_printer

    def index
      @tasks = @mqtt_printer.tasks.order(id: :desc).page(params[:page])
    end

    def clear
      @mqtt_printer.tasks.todo.delete_all
    end

    private
    def set_mqtt_printer
      @mqtt_printer = MqttPrinter.find params[:mqtt_printer_id]
    end

  end
end

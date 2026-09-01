module Print
  class Panel::TasksController < Panel::BaseController
    before_action :set_mqtt_printer, except: [:recent, :todo]
    before_action :set_task, only: [:show, :edit, :update, :destroy, :resend]

    def index
      @tasks = @mqtt_printer.tasks.order(id: :desc).page(params[:page])
    end

    def recent
      @tasks = Task.order(id: :desc).page(params[:page])
    end

    def todo
      @tasks = Task.todo.order(id: :desc).page(params[:page])
    end

    def clear
      @mqtt_printer.tasks.todo.delete_all
    end

    def resend
      @task.print
      head :ok
    end

    private
    def set_mqtt_printer
      @mqtt_printer = MqttPrinter.find params[:mqtt_printer_id]
    end

    def set_task
      @task = @mqtt_printer.tasks.find params[:id]
    end

  end
end

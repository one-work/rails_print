module Print
  class Admin::TemplateTasksController < Admin::BaseController
    before_action :set_template
    before_action :set_new_template_task, only: [:new, :create]

    def index
      @template_tasks = @template.template_tasks.where(default_params).order(id: :desc).page(params[:page])
    end

    def create
      @template_task.save

      @printer_aims = PrinterAim.includes(:printer).where(printer: { online: true }, **default_params)
      if @printer_aims.length == 1
        @printer = @printer_aims.take.printer
        if params.exclude?(:dev_type) && @printer.dev_type == 'cpcl' || (params.include?(:dev_type) && @printer.dev_type != params[:dev_type])
          render :inner_type
        else
          if @printer.is_a? Print::BluetoothPrinter
            @data = {
              device: @printer.name,
              raw: @template_task.raw
            }
          else
            render 'alert_message', locals: { message: '打印指令已下发至云打印机，网络不好可能存在一定延迟！' }
          end
        end
      elsif @printer_aims.length > 1
        render :inner_choose
      else
        @data = {
          raw: @template_task.raw
        }
        render :inner_blank
      end
    end

    private
    def set_template
      @template = Template.find params[:template_id]
    end

    def set_new_template_task
      @template_task = @template.template_tasks.build
      @template_task.organ = current_organ
      @template_task.payload = template_task_params
    end

    def set_mqtt_printers
      @mqtt_printers = MqttPrinter.where(online: true).default_where(default_params)
    end

    def template_task_params
      params.fetch(:template_task, {}).permit!
    end

  end
end

module Print
  class Admin::HomeController < Admin::BaseController
    before_action :set_printer, only: [:task]

    def index
      @mqtt_printers = MqttPrinter.includes(:printer_aims).where(printer_aims: { organ_id: current_organ.id }).page(params[:page])
      @bluetooth_printers = BluetoothPrinter.includes(:printer_aims).where(printer_aims: { organ_id: current_organ.id }).page(params[:page])
    end

    def bind
      @mqtt_printers = MqttPrinter.includes(:printer_aims).where(printer_aims: { organ_id: current_organ.id, aim: 'demo' }).page(params[:page])
    end

    def scan
      if params[:result].include?('&')
        name, addr = params[:result].split('&')

        printer = BluetoothPrinter.find_or_create_by(name: name, bluetooth_addr: addr)
        printer.save
      else
        printer = MqttPrinter.find_by(dev_imei: params[:result])
      end

      printer.printer_aims.find_or_initialize_by(aim: 'demo', **default_form_params)
      printer.save!
    end

    def replace
      printer_aim = PrinterAim.where(aim: 'demo', **default_params).take
      mqtt_printer = MqttPrinter.find_by(dev_imei: params[:result])

      if printer_aim
        printer_aim.printer = mqtt_printer
        printer_aim.save!
      else
        mqtt_printer.printer_aims.build(aim: 'demo', **default_form_params)
        mqtt_printer.save!
      end
    end

    def replace_bluetooth
      printer_aim = PrinterAim.where(aim: 'demo', **default_params).take
      mqtt_printer = MqttPrinter.find_by(dev_imei: params[:result])

      if printer_aim
        printer_aim.printer = mqtt_printer
        printer_aim.save!
      else
        mqtt_printer.printer_aims.build(aim: 'demo', **default_form_params)
        mqtt_printer.save!
      end
    end

    def inner
      @printer_aims = PrinterAim.includes(:printer).where(printer: { online: true }, aim: params[:aim], **default_params)
      if @printer_aims.blank?
        @printer_aims = PrinterAim.includes(:printer).where(printer: { online: true }, **default_params)
      end

      if @printer_aims.length == 1
        @printer = @printer_aims.take.printer
        @task = @printer.inner_tasks.build(gid: params[:gid], aim: params[:aim])
        @task.save

        if @printer.is_a? Print::BluetoothPrinter
          @data = {
            #url: url_for(controller: 'print/api/tasks', action: 'show', auth_token: Current.session.once_token, only_path: false),
            device: @printer.name,
            raw: @task.raw
          }
        else
          head :ok
        end
      elsif @printer_aims.length > 1
        render :inner_choose
      else
        render :inner_blank
      end
    end

    def task
      @task = @printer.inner_tasks.build(gid: params[:gid], aim: params[:aim])
      @task.save

      if @printer.is_a? Print::BluetoothPrinter
        @data = {
          #url: url_for(controller: 'print/api/tasks', action: 'show', auth_token: Current.session.once_token, only_path: false),
          device: @printer.name,
          raw: @task.raw
        }
        render :inner
      else
        head :ok
      end
    end

    private
    def set_printer
      @printer = Printer.find params[:printer_id]
    end

  end
end

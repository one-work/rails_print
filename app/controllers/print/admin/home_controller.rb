module Print
  class Admin::HomeController < Admin::BaseController

    def index
      @mqtt_printers = MqttPrinter.includes(:printer_organs).where(printer_organs: { organ_id: current_organ.id }).page(params[:page])
      @bluetooth_printers = BluetoothPrinter.includes(:printer_organs).where(printer_organs: { organ_id: current_organ.id }).page(params[:page])
    end

    def bind
      @mqtt_printers = MqttPrinter.includes(:printer_aims).where(printer_aims: { organ_id: current_organ.id, aim: 'demo' }).page(params[:page])
    end

    def scan
      if params[:result].include?('&')
        name, _ = params[:result].split('&')

        bluetooth_printer = BluetoothPrinter.find_or_create_by(name: name)
        bluetooth_printer.save
      else
        printer = MqttPrinter.find_by(dev_imei: params[:result])
      end

      printer.organ = current_organ
      printer.printer_aims.find_or_initialize_by(aim: 'produce', **default_form_params)
      printer.printer_aims.find_or_initialize_by(aim: 'receipt', **default_form_params)
      printer.save!
    end

    def replace
      printer_aim = PrinterAim.where(aim: 'demo', **default_params).take
      mqtt_printer = MqttPrinter.find_by(dev_imei: params[:result])

      if printer_aim
        printer_aim.printer = mqtt_printer
      else
        mqtt_printer.printer_aims.build(aim: 'demo', **default_form_params)
        mqtt_printer.save!
      end
    end

    def inner
      printer_aim = PrinterAim.where(aim: params[:aim], **default_params).take

      if printer_aim
        @printer = printer_aim.printer
        @task = printer_aim.inner_tasks.build(gid: params[:gid], aim: params[:aim])
        @task.save

        if @printer.is_a? Print::BluetoothPrinter
          @data = {
            #url: url_for(controller: 'print/api/tasks', action: 'show', auth_token: Current.session.once_token, only_path: false),
            device: @printer.name,
            raw: @task.raw
          }
        else
          @task.print
          head :ok
        end
      else
        redirect_to action: 'index'
      end
    end

  end
end

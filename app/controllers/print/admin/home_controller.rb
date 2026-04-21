module Print
  class Admin::HomeController < Admin::BaseController

    def index
      @mqtt_printers = MqttPrinter.where(default_params).page(params[:page])
      @bluetooth_printers = BluetoothPrinter.where(default_params).page(params[:page])
    end

    def bind
      @mqtt_printers = MqttPrinter.includes(:devices).where(default_params).where(devices: { aim: 'demo' }).page(params[:page])
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
        mqtt_printer.printer_aims.build(aim: 'demo')
        mqtt_printer.save!
      end
    end

    def inner
      printer_aim = PrinterAim.where(aim: params[:aim], **default_params).take

      if printer_aim
        @task = @printer_aim.inner_tasks.build(gid: params[:gid], aim: params[:aim])
        @task.save
      end
    end

  end
end

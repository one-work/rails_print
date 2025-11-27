module Print
  class Admin::HomeController < Admin::BaseController

    def index
    end

    def scan
      if params[:result].include?('&')
        name, _ = params[:result].split('&')

        bluetooth_printer = BluetoothPrinter.find_or_create_by(name: name, **default_form_params)
        bluetooth_printer.save
      else
        mqtt_printer = MqttPrinter.find_by(dev_imei: params[:result])
        mqtt_printer.organ = current_organ
        mqtt_printer.save!
      end
    end

  end
end

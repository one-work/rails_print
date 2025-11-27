module Print
  class Panel::MqttPrintersController < Panel::BaseController
    before_action :set_mqtt_printer, only: [:show, :edit, :update, :destroy, :actions, :organ]

    def search_organs
      @organs = Org::Organ.default_where('name-like': params['name-like'])
    end

    private
    def set_mqtt_printer
      @mqtt_printer = MqttPrinter.find(params[:id])
    end

  end
end

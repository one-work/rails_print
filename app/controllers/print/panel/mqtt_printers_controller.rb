module Print
  class Panel::MqttPrintersController < Panel::BaseController
    before_action :set_mqtt_printer, only: [:show, :edit, :update, :destroy, :actions, :organ]

    def index
      q_params = {}
      q_params.merge! params.permit(:dev_imei, :online)

      @mqtt_printers = MqttPrinter.where(q_params).page(params[:page])
    end

    def search_organs
      @organs = Org::Organ.default_where('name-like': params['name-like'])
    end

    private
    def set_mqtt_printer
      @mqtt_printer = MqttPrinter.find(params[:id])
    end

    def set_filter_columns
      @filter_columns = set_filter_i18n(
        'online' => { type: 'dropdown', default: true },
        'dev_imei' => { type: 'search', default: true }
      )
    end

  end
end

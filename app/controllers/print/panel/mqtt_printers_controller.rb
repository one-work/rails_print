module Print
  class Panel::MqttPrintersController < Panel::BaseController
    before_action :set_mqtt_printer, only: [:show, :edit, :update, :destroy, :actions, :organ, :dev_type]

    def index
      q_params = {}
      q_params.merge! params.permit(:dev_imei, :online, :id)

      @mqtt_printers = MqttPrinter.includes(printer_aims: :organ).where(q_params).order(ready_at: :desc).page(params[:page])
    end

    def search_organs
      @organs = Org::Organ.default_where('name-like': params['name-like'])
    end

    def dev_type
      @mqtt_printer.set_dev_type!(params[:dev_type])
    end

    def step
      @mqtt_printer.set_step!(params[:step])
    end

    private
    def set_mqtt_printer
      @mqtt_printer = MqttPrinter.find(params[:id])
    end

    def set_filter_columns
      @filter_columns = set_filter_i18n(
        'online' => { type: 'dropdown', default: true },
        'dev_imei' => { type: 'search', default: true },
        'id' => { type: 'search', default: true }
      )
    end

    def mqtt_printer_params
      params.fetch(:mqtt_printer, {}).permit(
        :online
      )
    end

  end
end

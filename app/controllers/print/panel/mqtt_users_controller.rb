module Print
  class Panel::MqttUsersController < Panel::BaseController
    before_action :set_mqtt_user, only: [:show, :edit, :edit_ip, :update, :destroy, :actions]
    before_action :set_new_mqtt_user, only: [:new, :new_ip, :create]

    def index
      @mqtt_users = MqttUser.where(ip: nil).page(params[:page])
    end

    def ip
      @mqtt_users = MqttUser.where.not(ip: nil).page(params[:page])
    end

    private
    def set_mqtt_user
      @mqtt_user = MqttUser.find(params[:id])
    end

    def set_new_mqtt_user
      @mqtt_user = MqttUser.new(mqtt_user_params)
    end

    def mqtt_user_params
      params.fetch(:mqtt_user, {}).permit(
        :username,
        :note,
        :password,
        :ip,
        :is_superuser
      )
    end
  end
end

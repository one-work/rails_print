module Print
  class Panel::MqttUsersController < Panel::BaseController

    def index
      @mqtt_users = MqttUser.where(ip: nil).page(params[:page])
    end

    def ip
      @mqtt_users = MqttUser.where.not(ip: nil).page(params[:page])
    end

    private
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

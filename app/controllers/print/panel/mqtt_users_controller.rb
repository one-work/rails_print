module Print
  class Panel::MqttUsersController < Panel::BaseController

    private
    def mqtt_user_params
      params.fetch(:mqtt_user, {}).permit(
        :username,
        :password,
        :ip,
        :is_superuser
      )
    end
  end
end

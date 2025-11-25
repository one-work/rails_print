# frozen_string_literal: true
module Print
  class EmqxApi
    include CommonApi

    def clients(**options)
      r = get 'clients', origin: @app.base_url, **options
      r['data']
    end

    def publish(topic, payload, retain = false, qos = 2, **options)
      post 'publish', topic: topic, payload: payload, retain: retain, qos: qos, **options
    end

    private
    def with_access_token(tries: 2, params: {}, headers: {}, payload: {})
      @client.plugin(:basic_auth).basic_auth(Rails.application.credentials.dig(:emqx, :key), Rails.application.credentials.dig(:emqx, :secret))
      yield
    end

  end
end

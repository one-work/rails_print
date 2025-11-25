# frozen_string_literal: true
module Print
  class EmqxApi
    include CommonApi
    BASE = 'http://linli-emqx:18083/api/v5/'

    def clients(**options)
      r = get 'clients', origin: BASE, **options
      r['data']
    end

    def publish(topic, payload, retain = false, qos = 2, **options)
      post 'publish', topic: topic, payload: payload, retain: retain, qos: qos, origin: BASE, **options
    end

    private
    def with_access_token(tries: 2, params: {}, headers: {}, payload: {})
      @client = @client.plugin(:basic_auth).basic_auth(Rails.application.credentials.dig(:emqx, :key), Rails.application.credentials.dig(:emqx, :secret))
      yield
    end

  end
end

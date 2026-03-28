# frozen_string_literal: true
module Print
  module EmqxApi
    extend CommonApi
    extend self
    BASE = "#{Rails.application.credentials.dig(:emqx, :host)}/api/v5/"

    def base_url
      BASE
    end

    def clients(**options)
      r = get 'clients', origin: BASE, **options
      r['data']
    end

    def auth
      get 'authentication'
    end

    def auth_ips(*ips, **options)
      checks = ips.each_with_object([]) do |ip, arr|
        arr << { is_match: "str_eq(peerhost, '#{ip}')", result: 'allow' }
      end

      put 'authentication/cinfo', checks: checks, mechanism: 'cinfo', **options
    end

    def publish(topic, payload, retain = false, qos = 2, **options)
      post 'publish', topic: topic, payload: payload, retain: retain, qos: qos, origin: BASE, **options
    end

    private
    def with_access_token(tries: 2, params: {}, headers: {}, payload: {}, **)
      @client = @client.plugin(:basic_auth).basic_auth(Rails.application.credentials.dig(:emqx, :key), Rails.application.credentials.dig(:emqx, :secret))
      yield
    end

  end
end

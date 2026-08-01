# frozen_string_literal: true
module Print
  module EmqxApi
    extend CommonApi
    extend self

    def base_url
      return @base_url if defined? @base_url
      @base_url = "#{Rails.app.creds.require(:emqx, :host)}/api/v5/"
    end

    def clients(**options)
      r = get 'clients', **options
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
      post 'publish', topic: topic, payload: payload, retain: retain, qos: qos, **options
    end

    private
    def with_access_token(tries: 2, params: {}, headers: {}, payload: {}, **)
      @client = @client.plugin(:basic_auth).basic_auth(Rails.app.creds.require(:emqx, :key), Rails.app.creds.require(:emqx, :secret))
      yield
    end

  end
end

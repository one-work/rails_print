# frozen_string_literal: true

module JiaBo
  class BaseApi
    include CommonApi

    def post(path, params: {}, headers: {}, origin: nil, debug: nil, **payload)
      with_options = { origin: origin }
      with_options.merge! debug: STDOUT, debug_level: 2 if debug

      with_access_token(params: params, headers: headers, payload: payload) do
        params.merge! debug: 1 if debug
        response = @client.with_headers(headers).with(with_options).post(path, params: params, form: payload)
        debug ? response : parse_response(response)
      end
    end

    private
    def with_access_token(params: {}, headers: {}, payload: {}, tries: 2, **)
      payload.merge!(
        reqTime: (Time.current.to_f * 1000).round.to_s,
        memberCode: @app.member_code
      )
      payload.merge! securityCode: Digest::MD5.hexdigest([payload[:memberCode], payload[:reqTime], @app.api_key].join)
      yield
    end
  end
end

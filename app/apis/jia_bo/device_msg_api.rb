# frozen_string_literal: true

module JiaBo
  class DeviceMsgApi < BaseApi
    BASE = 'https://api.poscom.cn/apisc/'

    def msg(payload)
      post 'sendMsg', origin: BASE, **payload
    end

    private
    def with_access_token(params: {}, headers: {}, payload: {}, **)
      payload.merge!(
        reqTime: (Time.current.to_f * 1000).round.to_s,
        memberCode: @app.jia_bo_app.member_code,
        deviceID: @app.device_id
      )
      payload.merge! securityCode: Digest::MD5.hexdigest([payload[:memberCode], @app.device_id, payload[:msgNo], payload[:reqTime], @app.jia_bo_app.api_key].join)
      yield
    end

  end
end

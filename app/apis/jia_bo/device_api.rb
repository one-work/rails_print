# frozen_string_literal: true

module JiaBo
  class DeviceApi < BaseApi
    BASE = 'https://api.poscom.cn/apisc/'

    def send_volume(level)
      post 'sendVolume', origin: BASE, volume: level
    end

    def cancel_print(params)
      post 'cancelPrint', origin: BASE, **params
    end

    def add_dev(params)
      post 'adddev', origin: BASE, **params
    end

    def del_dev
      post 'deldev', origin: BASE
    end

    private
    def with_access_token(params: {}, headers: {}, payload: {}, **)
      payload.merge!(
        reqTime: (Time.current.to_f * 1000).round.to_s,
        memberCode: @app.jia_bo_app.member_code,
        deviceID: @app.device_id
      )
      payload.merge! securityCode: Digest::MD5.hexdigest([payload[:memberCode], payload[:reqTime], @app.jia_bo_app.api_key, @app.device_id].join)
      yield
    end

  end
end

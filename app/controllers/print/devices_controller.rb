module Bluetooth
  class DevicesController < BaseController

    def index
      @devices = Device.default_where(default_params).page(params[:page])

      render json: { devices: @devices.pluck(:name) }
    end

    def err
      @err = Err.new(err_msg: params.dig('message', 'errMsg'))
      @err.save

      head :ok
    end

    def test
      cpcl = BaseCpcl.new
      cpcl.text '打印机测试'
      cpcl.qrcode_right('dayinjiceshi', y: 20)

      render json: cpcl.render.bytes
    end

  end
end

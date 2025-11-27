module Bluetooth
  class Admin::DevicesController < Admin::BaseController
    before_action :set_new_device, only: [:new, :create, :scan]

    def scan
      name, _ = params[:result].split('&')
      @device.name = name
      @device.save
    end

    private
    def set_new_device
      @device = Device.new(device_params)
    end

    def device_params
      p = params.fetch(:device, {}).permit(
        :name
      )
      p.merge! default_params
    end

  end
end

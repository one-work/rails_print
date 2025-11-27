module Print
  class Admin::HomeController < Admin::BaseController

    def index
    end

    def scan
      if params[:result].include?('&')
        name, _ = params[:result].split('&')
      else
      end

      @device.name = name
      @device.save
    end

  end
end

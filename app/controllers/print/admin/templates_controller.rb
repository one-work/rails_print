module Print
  class Admin::TemplatesController < Panel::TemplatesController
    include Roled::Controller::Admin

    def index
      @templates = Template.where(organ_id: nil).page(params[:page])
    end

  end
end

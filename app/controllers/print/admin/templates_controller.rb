module Print
  class Admin::TemplatesController < Panel::TemplatesController
    include Roled::Controller::Admin

    def index
      @templates = Template.where(organ_id: nil).page(params[:page])
      @templates_owned = Template.where(default_params).page(params[:page])
    end

    private
    def template_params
      super.merge! default_form_params
    end

  end
end

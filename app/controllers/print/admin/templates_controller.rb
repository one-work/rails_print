module Print
  class Admin::TemplatesController < Panel::TemplatesController
    include Roled::Controller::Admin

    def index
      @templates_owned = Template.where(default_params).order(id: :desc).page(params[:page])
      @templates = Template.where(organ_id: nil).order(id: :desc).page(params[:page])
    end

    private
    def template_params
      super.merge! default_form_params
    end

  end
end

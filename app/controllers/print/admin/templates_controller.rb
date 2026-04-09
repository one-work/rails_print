module Print
  class Admin::TemplatesController < Panel::TemplatesController

    def index
      @templates = Template.where(organ_id: nil).page(params[:page])
    end

  end
end

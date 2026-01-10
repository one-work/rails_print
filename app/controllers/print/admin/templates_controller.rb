module Print
  class Admin::TemplatesController < Admin::BaseController

    def index
      @templates = Template.where(organ_id: nil).page(params[:page])
    end

  end
end

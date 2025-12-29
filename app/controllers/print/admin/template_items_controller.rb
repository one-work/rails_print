module Print
  class Admin::TemplateItemsController < Admin::BaseController

    private
    def set_template
      @template = Template.find params[:template_id]
    end
  end
end

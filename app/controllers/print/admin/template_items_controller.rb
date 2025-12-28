module Print
  class Panel::TemplateItemsController < Panel::BaseController

    private
    def set_template
      @template = Template.find params[:template_id]
    end
  end
end

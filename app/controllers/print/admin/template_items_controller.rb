module Print
  class Admin::TemplateItemsController < Panel::TemplateItemsController

    private
    def set_template
      @template = Template.find params[:template_id]
    end
  end
end

module Print
  class Panel::TemplateItemsController < Panel::BaseController
    before_action :set_template
    before_action :set_create_template_item, only: [:create]

    private
    def set_template
      @template = Template.find params[:template_id]
    end

    def set_create_template_item
      @template_item = @template.template_items.build(template_item_params)
    end

    def template_item_params
      params.expect(template_item: [:name, :code])
    end

  end
end

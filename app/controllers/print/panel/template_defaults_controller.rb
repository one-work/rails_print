module Print
  class Panel::TemplateDefaultsController < Panel::TemplateItemsController
    before_action :set_template_default, only: [:show, :edit, :update, :destroy]

    private
    def set_template_default
      @template_default = @template.template_items.find(params[:id])
    end

    def set_new_template_item
      @template_default = @template.template_items.build(type: 'Print::TemplateDefault')
    end

    def set_create_template_item
      @template_default = @template.template_items.build(type: 'Print::TemplateDefault')
      @template_default.assign_attributes template_default_params
    end

    def template_default_params
      params.expect(template_default: [:name, :code, :kind])
    end

  end
end

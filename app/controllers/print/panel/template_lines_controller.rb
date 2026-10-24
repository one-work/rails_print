module Print
  class Panel::TemplateLinesController < Panel::TemplateItemsController
    before_action :set_template_line, only: [:show, :edit, :update, :destroy]

    private
    def set_template_line
      @template_line = @template.template_items.find(params[:id])
    end

    def set_new_template_item
      @template_line = @template.template_items.build(type: 'Print::TemplateLine')
    end

    def set_create_template_item
      @template_line = @template.template_items.build(type: 'Print::TemplateLine')
      @template_line.assign_attributes template_line_params
    end

    def template_line_params
      params.expect(template_line: [:name, :code, :kind])
    end

  end
end

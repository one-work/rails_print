module Print
  class Panel::TemplateLinesController < Panel::BaseController
    before_action :set_template
    before_action :set_template_line, only: [:show, :edit, :update, :destroy]
    before_action :set_create_template_line, only: [:new, :create]

    def index
      @template_lines = @template.template_lines.order(position: :asc).page(params[:page])
    end

    private
    def set_template
      @template = Template.find params[:template_id]
    end

    def set_template_line
      @template_line = @template.template_items.find(params[:id])
    end

    def set_create_template_line
      @template_line = @template.template_items.build(type: 'Print::TemplateLine')
    end

    def template_line_params
      params.expect(template_line: [:name, :code, :kind])
    end

  end
end

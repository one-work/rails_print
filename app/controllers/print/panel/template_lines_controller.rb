module Print
  class Panel::TemplateLinesController < Panel::BaseController
    before_action :set_template
    before_action :set_template_line, only: [:show, :edit, :update, :destroy, :edit_table, :update_table]
    before_action :set_create_template_line, only: [:create]

    def index
      @template_lines = @template.template_lines.order(position: :asc).page(params[:page])
    end

    def new
      @template_line = @template.template_lines.build(type: 'Print::TemplateTable')
      @template_line.template_table_items.build
    end

    def create
      @template_line = @template.template_lines.build(type: 'Print::TemplateTable')
      @template_line.assign_attributes(template_table_params)
      @template_line.save
    end

    private
    def set_template
      @template = Template.find params[:template_id]
    end

    def set_template_line
      @template_line = @template.template_lines.find(params[:id])
    end

    def set_create_template_line
      @template_line = @template.template_lines.build(template_line_params)
    end

    def template_line_params
      params.expect(template_line: [:name, :code, :kind])
    end

  end
end

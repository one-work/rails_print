module Print
  class Panel::TemplateTablesController < Panel::BaseController
    before_action :set_template
    before_action :set_template_table, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_template_table, only: [:new, :create]

    def index
      @template_tables = @template.template_tables.order(position: :asc).page(params[:page])
    end

    def new
      @template_table = @template.template_tables.build(type: 'Print::TemplateTable')
      @template_table.template_table_items.build
    end

    def create
      @template_table = @template.template_tables.build(type: 'Print::TemplateTable')
      @template_table.assign_attributes(template_table_params)
      @template_table.save
    end

    private
    def set_template
      @template = Template.find params[:template_id]
    end

    def set_template_table
      @template_table = @template.template_tables.find(params[:id])
    end

    def set_create_template_table
      @template_table = @template.template_tables.build(template_table_params)
    end

    def template_table_params
      params.fetch(:template_table, {}).permit(
        :name,
        :code,
        template_table_items_attributes: [:name, :width, :_destroy]
      )
    end

  end
end

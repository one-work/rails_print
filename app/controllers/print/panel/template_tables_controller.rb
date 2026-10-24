module Print
  class Panel::TemplateTablesController < Panel::BaseController
    before_action :set_template
    before_action :set_template_table, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_template_table, only: [:new, :create]

    def new
      @template_table.template_table_items.build
    end

    private
    def set_template
      @template = Template.find params[:template_id]
    end

    def set_template_table
      @template_table = @template.template_tables.find(params[:id])
    end

    def set_new_template_table
      @template_table = @template.template_items.build(type: 'Print::TemplateTable')
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

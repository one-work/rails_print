module Print
  class Panel::TemplateTablesController < Panel::TemplateItemsController
    before_action :set_template_table, only: [:show, :edit, :update, :destroy, :actions]

    def new
      @template_table.template_table_items.build
    end

    private
    def set_template_table
      @template_table = @template.template_items.find(params[:id])
    end

    def set_new_template_item
      @template_table = @template.template_items.build(type: 'Print::TemplateTable')
    end

    def set_create_template_item
      @template_table = @template.template_items.build(type: 'Print::TemplateTable')
      @template_table.assign_attributes template_table_params
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

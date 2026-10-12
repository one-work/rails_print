module Print
  class Panel::TemplateItemsController < Panel::BaseController
    before_action :set_template
    before_action :set_create_template_item, only: [:create]

    def index
      @template_items = @template.template_items.order(position: :asc).page(params[:page])
    end

    def new_table
      @template_item = @template.template_items.build(type: 'Print::TemplateTable')
      @template_item.template_table_items.build
    end

    def create_table
      @template_item = @template.template_items.build(type: 'Print::TemplateTable')
      @template_item.assign_attributes(template_table_params)
      @template_item.save
    end

    private
    def set_template
      @template = Template.find params[:template_id]
    end

    def set_create_template_item
      @template_item = @template.template_items.build(template_item_params)
    end

    def template_item_params
      params.expect(template_item: [:name, :code, :kind])
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

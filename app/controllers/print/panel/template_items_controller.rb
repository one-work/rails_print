module Print
  class Panel::TemplateItemsController < Panel::BaseController
    before_action :set_template
    before_action :set_template_item, only: [:show, :edit, :update, :destroy, :edit_table, :update_table]
    before_action :set_create_template_item, only: [:create]

    def index
      @template_items = @template.template_items.order(position: :asc).page(params[:page])
    end

    private
    def set_template
      @template = Template.find params[:template_id]
    end

    def set_template_item
      @template_item = @template.template_items.find(params[:id])
    end

    def set_create_template_item
      @template_item = @template.template_items.build(template_item_params)
    end

    def template_item_params
      params.expect(template_item: [:name, :code, :kind])
    end

  end
end

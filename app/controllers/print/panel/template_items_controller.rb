module Print
  class Panel::TemplateItemsController < Panel::BaseController
    before_action :set_template
    before_action :set_template_item, only: [:show, :edit, :update, :destroy]
    before_action :set_new_template_item, only: [:new]
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

  end
end

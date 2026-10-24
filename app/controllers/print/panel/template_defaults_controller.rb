module Print
  class Panel::TemplateDefaultsController < Panel::BaseController
    before_action :set_template
    before_action :set_template_default, only: [:show, :edit, :update, :destroy, :edit_table, :update_table]
    before_action :set_create_template_default, only: [:create]

    def index
      @template_defaults = @template.template_defaults.order(position: :asc).page(params[:page])
    end

    def new
      @template_default = @template.template_defaults.build(type: 'Print::TemplateTable')
      @template_default.template_table_items.build
    end

    def create
      @template_default = @template.template_defaults.build(type: 'Print::TemplateTable')
      @template_default.assign_attributes(template_table_params)
      @template_default.save
    end

    private
    def set_template
      @template = Template.find params[:template_id]
    end

    def set_template_default
      @template_default = @template.template_defaults.find(params[:id])
    end

    def set_new_template_default
      @template_default = @template.template_defaults.build(template_default_params)
    end

    def template_default_params
      params.expect(template_default: [:name, :code, :kind])
    end

  end
end

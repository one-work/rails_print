module Print
  class Panel::TemplateDefaultsController < Panel::BaseController
    before_action :set_template
    before_action :set_template_default, only: [:show, :edit, :update, :destroy]
    before_action :set_new_template_default, only: [:new, :create]

    private
    def set_template
      @template = Template.find params[:template_id]
    end

    def set_template_default
      @template_default = @template.template_defaults.find(params[:id])
    end

    def set_new_template_default
      @template_default = @template.template_items.build(type: 'Print::TemplateDefault')
    end

    def template_default_params
      params.expect(template_default: [:name, :code, :kind])
    end

  end
end

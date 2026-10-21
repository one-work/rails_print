module Print
  class Panel::TemplatesController < Panel::BaseController

    private
    def template_params
      params.fetch(:template, {}).permit(
        :name
      )
    end

  end
end

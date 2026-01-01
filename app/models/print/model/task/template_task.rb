module Print
  module Model::Task::TemplateTask
    extend ActiveSupport::Concern

    included do
      belongs_to :template
    end

  end
end

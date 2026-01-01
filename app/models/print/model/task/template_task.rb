module Print
  module Model::Task::TemplateTask
    extend ActiveSupport::Concern

    included do
      belongs_to :template
      belongs_to :mqtt_printer
    end

  end
end

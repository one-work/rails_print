module Print
  module Model::Task::TemplateTask
    extend ActiveSupport::Concern

    included do
      attribute :payload, :json

      belongs_to :template
      belongs_to :mqtt_printer
    end

    def body

    end

    def print
      mqtt_printer.print(self, &block)
    end

  end
end

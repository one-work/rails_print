module Print
  module Model::Task::TemplateTask
    extend ActiveSupport::Concern

    included do
      attribute :payload, :json, default: {}

      belongs_to :template
      belongs_to :mqtt_printer
    end

    def body
    end

    def print
      mqtt_printer.print(self) do |pr|
        payload.each do |key, value|
          pr.public_send template.code_kinds[key], value
        end
      end
    end

  end
end

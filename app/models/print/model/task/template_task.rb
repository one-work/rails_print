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
        template.code_kinds.each do |code, kind|
          value = payload[code]
          pr.public_send kind, value if value.present?
        end
      end
    end

  end
end

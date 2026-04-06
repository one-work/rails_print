module Print
  module Model::Task::TemplateTask
    extend ActiveSupport::Concern

    included do
      attribute :payload, :json, default: {}

      belongs_to :template

      before_create :set_raw
      after_create_commit :print
    end

    def body
    end

    def set_raw
      set_esc do |pr|
        template.code_kinds.each do |code, kind|
          value = payload[code]
          method = pr.method(kind)
          if method.arity == 0
            method.call
          else
            method.call(value)
          end
        end
      end
    end

    def print
      mqtt_printer || build_mqtt_printer
      mqtt_printer.print_cmd(raw_arr, id)
    end

  end
end

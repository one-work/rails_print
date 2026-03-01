module Print
  module Model::Task::DeferredTask
    extend ActiveSupport::Concern

    included do
      belongs_to :mqtt_printer, optional: true
    end

    def print
      if mqtt_printer
        mqtt_printer.print_cmd(raw, task.id)
      end
    end

  end
end

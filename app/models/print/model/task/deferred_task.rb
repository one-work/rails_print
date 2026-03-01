module Print
  module Model::Task::DeferredTask
    extend ActiveSupport::Concern

    def print
      if mqtt_printer
        mqtt_printer.print_cmd(raw_arr, task.id)
      end
    end

  end
end

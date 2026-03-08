module Print
  module Model::Task::RawTask
    extend ActiveSupport::Concern

    included do
      after_create_commit :print
    end

    def print
      if mqtt_printer
        mqtt_printer.print_cmd(raw_arr, id)
      end
    end
  end
end

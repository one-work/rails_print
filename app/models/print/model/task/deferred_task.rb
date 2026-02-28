module Print
  module Model::Task::DeferredTask
    extend ActiveSupport::Concern

    included do
      belongs_to :mqtt_printer, optional: true
    end

    def print
      if mqtt_printer
        pr = BaseEsc.new
        yield pr
        mqtt_printer(pr.body, id)
      end
    end

  end
end

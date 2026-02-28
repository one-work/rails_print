module Print
  module Model::Task::DeferredTask
    extend ActiveSupport::Concern

    included do
      belongs_to :mqtt_printer
    end

  end
end

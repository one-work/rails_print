module Print
  module Model::Task::RawTask
    extend ActiveSupport::Concern

    included do
      belongs_to :mqtt_printer
    end

  end
end

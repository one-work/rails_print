module Print
  module Model::Task::DeferredTask
    extend ActiveSupport::Concern

    included do
      belongs_to :printer
    end

  end
end

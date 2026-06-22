module Print
  module Model::Task::CommandTask
    extend ActiveSupport::Concern

    included do
      #after_create_commit :print
    end

  end
end

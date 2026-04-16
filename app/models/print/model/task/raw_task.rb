module Print
  module Model::Task::RawTask
    extend ActiveSupport::Concern

    included do
      after_create_commit :print
    end


  end
end

module Print
  module Model::Task::RawTask
    extend ActiveSupport::Concern

    included do
      belongs_to :printer

      after_create_commit :print
    end

  end
end

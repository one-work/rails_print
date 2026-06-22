module Print
  module Model::Task::CommandTask
    extend ActiveSupport::Concern

    included do
      after_create_commit :print
      after_save_commit :change_to_printer!, if: -> { completed_at.present? || saved_change_to_completed_at? }
    end

    def change_to_printer!
      printer.update(**payload)
    end

  end
end

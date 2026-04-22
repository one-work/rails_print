module Print
  module Model::Task::InnerTask
    extend ActiveSupport::Concern

    included do
      attribute :gid, :string

      before_create :generate_raw
      after_save_commit :sync_to_locator, if: :saved_change_to_completed_at?
    end

    def sync_to_locator
      return unless model
      _model = model
      _model.print_info ||= {}
      _model.print_info.merge! aim => completed_at.to_fs(:iso8601)
      _model.save
    end

    def model
      return @model if defined? @model
      @model = GlobalID::Locator.locate gid
    end

    def generate_raw
      pr = print_base
      model.to_esc(pr, aim: aim)
    end

  end
end

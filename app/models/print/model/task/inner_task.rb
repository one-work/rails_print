module Print
  module Model::Task::InnerTask
    extend ActiveSupport::Concern

    included do
      attribute :gid, :string

      belongs_to :device

      after_save_commit :sync_to_locator, if: :saved_change_to_completed_at?
    end

    def sync_to_locator
      _model = model
      _model.print_info ||= {}
      _model.print_info.merge! aim => completed_at.to_fs(:iso8601)
      _model.save
    end

    def model
      return @model if defined? @model
      @model = GlobalID::Locator.locate gid
    end

  end
end

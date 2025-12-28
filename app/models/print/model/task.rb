module Print
  module Model::Task
    extend ActiveSupport::Concern

    included do
      attribute :gid, :string
      attribute :aim, :string
      attribute :completed_at, :datetime
      attribute :body, :text

      belongs_to :device

      after_save_commit :sync_to_locator, if: :saved_change_to_completed_at?
    end

    def sync_to_locator
      model = model
      model.print_info ||= {}
      model.print_info.merge! aim => completed_at.to_fs(:iso8601)
      model.save
    end

    def locate_model
      GlobalID::Locator.locate gid
    end

  end
end

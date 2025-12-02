module Print
  module Model::Task
    extend ActiveSupport::Concern

    included do
      attribute :gid, :string
      attribute :aim, :string
      attribute :completed_at, :datetime

      after_save_commit :sync_to_locator, if: :saved_change_to_completed_at?
    end

    def sync_to_locator
      model = GlobalID::Locator.locate gid
      model.print_info ||= {}
      model.print_info.merge! aim => completed_at
      model.save
    end

  end
end

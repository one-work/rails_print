module Print
  module Model::Task
    extend ActiveSupport::Concern

    included do
      attribute :gid, :string
      attribute :aim, :string
      attribute :completed_at, :datetime
    end

  end
end

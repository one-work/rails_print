module Print
  module Model::Task
    extend ActiveSupport::Concern

    included do
      attribute :type, :string
      attribute :aim, :string
      attribute :completed_at, :datetime
      attribute :body, :text
    end

  end
end

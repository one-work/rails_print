module Bluetooth
  module Model::Device
    extend ActiveSupport::Concern

    included do
      attribute :name, :string

      belongs_to :organ, class_name: 'Org::Organ', optional: true

      validates :name, uniqueness: { scope: :organ_id }
    end

  end
end

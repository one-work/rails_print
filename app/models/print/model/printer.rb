module Print
  module Model::Printer
    extend ActiveSupport::Concern

    included do
      attribute :uid, :string

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      has_many :devices, as: :printer
      accepts_nested_attributes_for :devices
    end

  end
end
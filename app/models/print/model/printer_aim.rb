module Print
  module Model::PrinterAim
    extend ActiveSupport::Concern

    included do
      attribute :aim, :string

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :printer
    end

  end
end

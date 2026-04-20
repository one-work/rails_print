module Print
  module Model::PrinterOrgan
    extend ActiveSupport::Concern

    included do
      attribute :aim, :string

      belongs_to :organ, class_name: 'Org::Organ', optional: true
    end

  end
end

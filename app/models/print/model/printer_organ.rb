module Print
  module Model::PrinterOrgan
    extend ActiveSupport::Concern

    included do
      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :printer
    end

  end
end

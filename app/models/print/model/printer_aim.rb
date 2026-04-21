module Print
  module Model::PrinterAim
    extend ActiveSupport::Concern

    included do
      attribute :aim, :string

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :printer

      has_many :inner_tasks, primary_key: [:printer_id, :aim], foreign_key: [:printer_id, :aim]
    end

  end
end

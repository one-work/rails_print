# frozen_string_literal: true

module Print
  module Ext::Organ
    extend ActiveSupport::Concern

    included do
      attribute :printer_aims_count, :integer, default: 0

      has_many :printer_aims, class_name: 'Print::PrinterAim'
    end

    def get_printer(aim)
      printer_aims = PrinterAim.includes(:printer).where(printer: { online: true }, aim: aim, organ_id: self.id)
      if printer_aims.blank?
        printer_aims = PrinterAim.includes(:printer).where(printer: { online: true }, organ_id: self.id)
      end
      printer_aims.take.printer
    end

  end
end

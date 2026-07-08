# frozen_string_literal: true

module Print
  module Ext::Organ

    def get_printer(aim)
      printer_aims = PrinterAim.includes(:printer).where(printer: { online: true }, aim: aim, organ_id: self.id)
      if printer_aims.blank?
        printer_aims = PrinterAim.includes(:printer).where(printer: { online: true }, organ_id: self.id)
      end
      printer_aims.take.printer
    end

  end
end

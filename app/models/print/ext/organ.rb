# frozen_string_literal: true

module Print
  module Ext::Organ
    extend ActiveSupport::Concern

    included do
      attribute :printer_aims_count, :integer, default: 0
      attribute :printer_online, :boolean

      has_many :printer_aims, class_name: 'Print::PrinterAim'
      has_many :printers, class_name: 'Print::Printer', through: :printer_aims
    end

    def get_printer(aim)
      printer_aims = PrinterAim.includes(:printer).where(printer: { online: true }, aim: aim, organ_id: self.id)
      if printer_aims.blank?
        printer_aims = PrinterAim.includes(:printer).where(printer: { online: true }, organ_id: self.id)
      end
      printer_aims.take&.printer
    end

    def set_printer_online!
      self.printer_online = printers.pluck(:online).include? true
      self.save
    end

  end
end

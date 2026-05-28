module Print
  module Model::Printer::BluetoothPrinter
    extend ActiveSupport::Concern

    included do
      attribute :online, :boolean, default: true
    end

    def cmd(r)
    end

  end
end

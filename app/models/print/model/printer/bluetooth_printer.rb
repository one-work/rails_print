module Print
  module Model::Printer::BluetoothPrinter
    extend ActiveSupport::Concern

    included do
      attribute :online, :boolean, default: true
      attribute :bluetooth_addr, :string
    end

    def cmd(r)
    end

  end
end

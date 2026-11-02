module Print
  module Model::PrinterLog
    extend ActiveSupport::Concern

    included do
      attribute :note, :string

      belongs_to :printer
    end

  end
end

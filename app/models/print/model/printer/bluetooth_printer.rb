module Print
  module Model::BluetoothPrinter
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :dev_type, :integer
      attribute :dev_cut_type, :integer

      enum :dev_type, {
        cpcl: 1,
        esc: 2
      }, default: 'cpcl', prefix: true

      enum :dev_cut_type, {
        full: 0,
        partial: 1
      }, default: 'full', prefix: true

      belongs_to :organ, class_name: 'Org::Organ', optional: true

      has_many :devices, as: :printer, dependent: :delete_all
      accepts_nested_attributes_for :devices, allow_destroy: true



      validates :name, uniqueness: { scope: :organ_id }
    end

  end
end

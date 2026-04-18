module Print
  module Model::BluetoothPrinter
    extend ActiveSupport::Concern

    included do
      attribute :name, :string

      belongs_to :organ, class_name: 'Org::Organ', optional: true

      has_many :devices, as: :printer, dependent: :delete_all
      has_many :tasks, as: :printer, dependent: :delete_all
      has_many :template_tasks, as: :printer, dependent: :delete_all
      has_many :raw_tasks, as: :printer, dependent: :delete_all
      has_many :deferred_tasks, as: :printer, dependent: :delete_all
      has_many :inner_tasks, as: :printer, dependent: :delete_all

      validates :name, uniqueness: { scope: :organ_id }
    end

  end
end

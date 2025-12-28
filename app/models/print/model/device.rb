module Print
  module Model::Device
    extend ActiveSupport::Concern

    included do
      attribute :aim, :string

      enum :aim, {
        produce: 'produce',
        receipt: 'receipt'
      }, prefix: true

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :printer, polymorphic: true

      has_many :tasks

      before_validation :sync_organ_from_printer, if: :new_record?
    end

    def sync_organ_from_printer
      self.organ_id = printer.organ_id
    end

    def print(gid, &block)
      task = tasks.build(gid: gid, aim: aim)
      printer.print(task, &block)
    end

    def print_later
      PrintJob.perform_later(self)
    end

  end
end

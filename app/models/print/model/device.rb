module Print
  module Model::Device
    extend ActiveSupport::Concern

    included do
      attribute :aim, :string

      enum :aim, {
        produce: 'produce',
        receipt: 'receipt',
        demo: 'demo'
      }, prefix: true

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :printer

      before_validation :sync_organ_from_printer, if: :new_record?
    end

    def sync_organ_from_printer
      self.organ_id = printer.organ_id
    end

    def print(gid, &block)
      task = printer.inner_tasks.build(gid: gid, aim: aim)
      task.set_esc!(&block)
      task
    end

    def print_later
      PrintJob.perform_later(self)
    end

  end
end

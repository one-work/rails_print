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

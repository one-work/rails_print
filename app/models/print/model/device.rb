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

      task.set_esc!(&block)
      task
    end

  end
end

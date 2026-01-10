module Print
  module Model::Template
    extend ActiveSupport::Concern

    included do
      attribute :name, :string

      belongs_to :organ, class_name: 'Org::Organ', optional: true

      has_many :template_items
    end

    def code_kinds
      template_items.load.pluck(:code, :kind).to_h
    end

  end
end

module Print
  module Model::TemplateTableItem
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :width, :integer
      attribute :prefix, :string
      attribute :suffix, :string
      attribute :position, :integer
      attribute :input, :string

      enum :input, {
        date: 'date',
        datetime: 'datetime',
        integer: 'integer',
        decimal: 'decimal',
        string: 'string',
        text: 'text'
      }

      belongs_to :template_table

      positioned on: :template_table_id

      validates :name, uniqueness: { scope: :template_table_id }
    end

  end
end

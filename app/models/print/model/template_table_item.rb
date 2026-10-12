module Print
  module Model::TemplateTableItem
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :width, :string
      attribute :position, :integer

      belongs_to :template_table

      positioned on: :template_table_id

      validates :name, uniqueness: { scope: :template_table_id }
    end

  end
end

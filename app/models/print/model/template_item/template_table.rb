module Print
  module Model::TemplateItem::TemplateTable
    extend ActiveSupport::Concern

    included do
      has_many :template_table_items, dependent: :delete_all

      accepts_nested_attributes_for :template_table_items, allow_destroy: true
    end

  end
end

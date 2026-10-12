module Print
  module Model::TemplateItem::TemplateTable
    extend ActiveSupport::Concern

    included do
      has_many :template_table_items, dependent: :delete_all
    end


  end
end

module Print
  module Model::TemplateItem::TemplateTable
    extend ActiveSupport::Concern

    included do
      has_many :template_table_items, dependent: :delete_all

      accepts_nested_attributes_for :template_table_items, allow_destroy: true
    end

    def name_with_widths
      template_table_items.order(position: :asc).pluck(:name, :width).to_h
    end

    def name_with_blank
      template_table_items.order(position: :asc).pluck(:name).each_with_object({}) do |k, h|
        h.merge! k => nil
      end
    end

  end
end

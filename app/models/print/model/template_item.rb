module Print
  module Model::TemplateItem
    extend ActiveSupport::Concern

    included do
      attribute :type, :string
      attribute :name, :string
      attribute :code, :string
      attribute :position, :integer

      belongs_to :template

      positioned on: :template_id

      validates :code, uniqueness: { scope: :template_id }
    end

  end
end

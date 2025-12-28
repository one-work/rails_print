module Print
  module Model::TemplateItem
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :code, :string
      attribute :position, :integer

      enum :kind, {
        break_line: 'break_line',
        text: 'text',
        qrcode: 'qrcode'
      }

      positioned on: :template_id

      belongs_to :template
    end

  end
end

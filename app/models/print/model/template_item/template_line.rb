module Print
  module Model::TemplateItem::TemplateLine
    extend ActiveSupport::Concern

    included do
      attribute :unit, :string

      enum :kind, {
        text: 'text',
        qrcode: 'qrcode',
        dash: 'dash'
      }

      validates :code, uniqueness: { scope: :template_id }
    end

  end
end

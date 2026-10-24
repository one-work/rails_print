module Print
  module Model::TemplateItem::TemplateLine
    extend ActiveSupport::Concern

    included do
      enum :kind, {
        text: 'text',
        qrcode: 'qrcode',
        dash: 'dash'
      }
    end

  end
end

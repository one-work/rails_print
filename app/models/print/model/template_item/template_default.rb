module Print
  module Model::TemplateItem::TemplateDefault
    extend ActiveSupport::Concern

    included do
      enum :kind, {
        break_line: 'break_line',
        text: 'text',
        qrcode: 'qrcode',
        dash: 'dash'
      }
    end

  end
end

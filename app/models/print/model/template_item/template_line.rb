module Print
  module Model::TemplateItem::TemplateLine
    extend ActiveSupport::Concern

    included do
      attribute :unit, :string

      enum :kind, {
        text: 'text',
        text_center: 'text_center',
        text_big_center: 'text_big_center',
        qrcode: 'qrcode',
        qrcode_center: 'qrcode_center',
        dash: 'dash'
      }

      validates :code, uniqueness: { scope: :template_id }
    end

    def value_pr(pr, value)
      return if value.blank?
      if unit.present?
        _value = "#{name}：#{value}#{unit}"
      else
        _value = value
      end

      method = pr.method(kind)
      if [0, -1].include? method.arity
        method.call
      else
        method.call(_value)
      end
    end

  end
end

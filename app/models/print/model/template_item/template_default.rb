module Print
  module Model::TemplateItem::TemplateDefault
    extend ActiveSupport::Concern

    included do
      enum :kind, {
        break_line: 'break_line',
        text: 'text',
        qrcode: 'qrcode',
        dash: 'dash',
        time: 'time'
      }
    end

    def value(pr)
      case kind
      when 'time'
        pr.text "#{name}：#{Time.current.to_fs(:cn)}"
      else
        method = pr.method(kind)
        if [0, -1].include? method.arity
          method.call
        else
          method.call(name)
        end
      end
    end

  end
end

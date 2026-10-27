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

    def value_pr(pr)
      case kind
      when 'time'
        pr.text "#{name}：#{value}"
      else
        method = pr.method(kind)
        if [0, -1].include? method.arity
          method.call
        else
          method.call(name)
        end
      end
    end

    def value
      case kind
      when 'time'
        Time.current.to_fs(:cn)
      else
        code
      end
    end

  end
end

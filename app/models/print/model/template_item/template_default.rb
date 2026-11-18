module Print
  module Model::TemplateItem::TemplateDefault
    extend ActiveSupport::Concern

    included do
      enum :kind, {
        break_line: 'break_line',
        text: 'text',
        text_center: 'text_center',
        text_big_center: 'text_big_center',
        qrcode: 'qrcode',
        qrcode_center: 'qrcode_center',
        dash: 'dash',
        date: 'date',
        time: 'time',
        datetime: 'datetime'
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
      now = Time.current
      case kind
      when 'datetime'
        now.to_fs(:cn)
      when 'date'
        now.to_fs(:cn_date)
      when 'time'
        now.to_fs(:cn_time)
      else
        code
      end
    end

  end
end

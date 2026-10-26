module Print
  module Model::Task::TemplateTask
    extend ActiveSupport::Concern

    included do
      attribute :payload, :json, default: {}

      belongs_to :organ, class_name: 'Org::Organ', optional: true

      belongs_to :template
      belongs_to :printer, optional: true

      before_create :set_raw
      after_create_commit :print
    end

    def body
    end

    def set_raw
      set_esc do |pr|
        template.template_items.each do |template_item|
          if template_item.is_a?(TemplateTable)
            cols = payload[template_item.code].map { |i| i.values }
            pr.table(headers: template_item.name_with_widths, cols: cols)
          elsif template_item.is_a?(TemplateDefault)
            template_item.value(pr)
          else
            value = payload[template_item.code]
            method = pr.method(template_item.kind)
            if [0, -1].include? method.arity
              method.call
            else
              method.call(value)
            end
          end
        end
      end
    end

  end
end

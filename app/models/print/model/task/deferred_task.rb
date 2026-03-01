module Print
  module Model::Task::DeferredTask
    extend ActiveSupport::Concern

    included do
      belongs_to :mqtt_printer, optional: true
    end

    def print(text = '密码设置成功')
      if mqtt_printer
        mqtt_printer.print(id) do |pr|
          pr.text text
        end
      end
    end

  end
end

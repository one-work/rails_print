#require 'print_test_helper'
module Print
  class TasksControllerTest < ActionDispatch::IntegrationTest

    setup do
      @printer = MqttPrinter.new(id: '2222')
      @task = @printer.template_tasks.build()
    end

  end
end

require 'test_helper'
module Print
  class TasksControllerTest < ActionDispatch::IntegrationTest

    setup do
      @task = print_tasks(:one)
    end

    test 'create ok' do
      assert_difference('Task.count') do
        post(
          url_for(controller: 'print/tasks', action: 'create', printer_id: @task.mqtt_printer_id),
          params: {
            task: {
              body: @task.body
            }
          },
          as: :turbo_stream
        )
      end

      assert_response :success
    end

  end
end

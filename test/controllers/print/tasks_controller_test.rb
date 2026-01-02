require 'test_helper'
module Print
  class TasksControllerTest < ActionDispatch::IntegrationTest

    setup do
      @task = print_tasks(:one)
      binding.b
    end

    test 'create ok' do
      assert_difference('Task.count') do
        post(
          url_for(controller: 'tasks', action: 'create'),
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

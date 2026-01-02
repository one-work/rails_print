require 'test_helper'
module Print
  class TasksControllerTest < ActionDispatch::IntegrationTest

    setup do
      @task = print_tasks(:one)
    end

    test 'index ok' do
      get url_for(controller: 'tasks')

      assert_response :success
    end

    test 'new ok' do
      get url_for(controller: 'tasks')

      assert_response :success
    end

    test 'create ok' do
      assert_difference('Task.count') do
        post(
          url_for(controller: 'tasks', action: 'create'),
          params: { task: { xx: @task.xx } },
          as: :turbo_stream
        )
      end

      assert_response :success
    end

    test 'show ok' do
      get url_for(controller: 'tasks', action: 'show', id: @task.id)

      assert_response :success
    end

    test 'edit ok' do
      get url_for(controller: 'tasks', action: 'edit', id: @task.id)

      assert_response :success
    end

    test 'update ok' do
      patch(
        url_for(controller: 'tasks', action: 'update', id: @task.id),
        params: { task: { xx: @task.xx } },
        as: :turbo_stream
      )

      assert_response :success
    end

    test 'destroy ok' do
      assert_difference('Task.count', -1) do
        delete url_for(controller: 'tasks', action: 'destroy', id: @task.id), as: :turbo_stream
      end

      assert_response :success
    end

  end
end

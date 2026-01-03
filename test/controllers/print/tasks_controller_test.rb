require 'print_test_helper'

module Print
  class TasksControllerTest < ActionDispatch::IntegrationTest

    setup do
      @model = print_tasks(:one)
      @params = @task.as_json(only: [:printer_id, :body])
    end

  end
end

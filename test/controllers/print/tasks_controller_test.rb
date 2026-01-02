require 'test_helper'

module Print
  class TasksControllerTest < ActionDispatch::IntegrationTest

    setup do
      @task = print_tasks(:one)
    end

    def test_create_ok
      super
    end

  end
end

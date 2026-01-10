#ActiveRecord::Migrator.migrations_paths = [File.expand_path('../test/dummy/db/migrate', __dir__)]

abort("Abort testing: Your Rails environment is running in production mode!") if Rails.env.production?

require 'active_support/test_case'
require 'rails/testing/maintain_test_schema'

if defined?(ActiveRecord::Base)
  require 'active_record/testing/query_assertions'
  ActiveSupport.on_load(:active_support_test_case) do
    include ActiveRecord::TestDatabases
    include ActiveRecord::TestFixtures
    include ActiveRecord::Assertions::QueryAssertions

    self.fixture_paths << [
      "#{Rails.root}/test/fixtures/",
      File.expand_path('../test/fixtures', __dir__)
    ]
    self.file_fixture_path = File.expand_path('../test/fixtures', __dir__) + '/files'
  end

  ActiveSupport.on_load(:action_dispatch_integration_test) do
    self.fixture_paths += ActiveSupport::TestCase.fixture_paths
  end
end

ActiveSupport.on_load(:action_controller_test_case) do
  def before_setup
    @routes = Rails.application.routes
    super
  end
end

ActiveSupport.on_load(:action_dispatch_integration_test) do
  def before_setup
    @routes = Rails.application.routes
    super
  end
end

if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
  ActiveSupport::TestCase.fixtures :all
end

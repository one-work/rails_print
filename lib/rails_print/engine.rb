require 'rails_com'
module RailsPrint
  class Engine < ::Rails::Engine

    config.autoload_paths += Dir[
      "#{config.root}/app/models/task",
    ]
    config.eager_load_paths += Dir[
      "#{config.root}/app/models/task",
    ]

    config.generators do |g|
      g.resource_route false
      g.rails = {
        assets: false,
        stylesheets: false,
        helper: false
      }
      g.template_engine nil
      g.test_unit = {
        fixture: true
      }
      g.templates.prepend File.expand_path('lib/templates', RailsCom::Engine.root)
    end

  end
end

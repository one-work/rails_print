require 'rails_com'
module RailsPrint
  class Engine < ::Rails::Engine

    def railtie_namespace
      Print
    end

    config.autoload_paths += Dir[
      "#{config.root}/app/models/task",
    ]
    config.eager_load_paths += Dir[
      "#{config.root}/app/models/task",
    ]

    config.generators do |g|
      g.rails = {
        assets: false,
        helper: false,
        resource_route: false,
        template_engine: nil
      }
      g.templates.prepend File.expand_path('lib/templates', RailsCom::Engine.root)
    end

  end
end

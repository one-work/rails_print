module RailsPrint
  class Engine < ::Rails::Engine

    config.autoload_paths += Dir[
      "#{config.root}/app/models/task",
    ]
    config.eager_load_paths += Dir[
      "#{config.root}/app/models/task",
    ]

  end
end

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module Yeung
  class Application < Rails::Application
    config.load_defaults 5.2
    config.active_job.queue_adapter = :delayed_job

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', headers: :any, methods: [:get, :post, :options]
      end
    end

    config.enable_dependency_loading = true
    config.eager_load_paths << Rails.root.join('app/entities')
    config.eager_load_paths << Rails.root.join('app/api')
    
    
  end
end

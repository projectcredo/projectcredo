require_relative 'boot'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Projectcredo
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # For adding subdirectories
    config.autoload_paths += Dir[
      Rails.root.join('app', 'models', '{**}', '{**}')
    ]

    config.autoload_paths << Rails.root.join('lib')

    # Include the authenticity token in remote forms.
    config.action_view.embed_authenticity_token_in_remote_forms = true

    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*',
          headers: :any,
          expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
          methods: [:get, :post, :options, :delete, :put]
      end
    end

    config.generators do |g|
      g.test_framework :rspec
      g.integration_tool :rspec
    end

    Raven.configure do |config|
      config.dsn = 'https://f999457a4654438080b41c4bd9e1c5a0:c3d7aad45f674cf08bea3a8068a7734b@sentry.io/1371890'
      config.environments = ['staging', 'production']
    end
  end
end

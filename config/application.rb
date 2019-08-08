require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Plataforma
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    config.i18n.default_locale = :'pt-BR'

    config.time_zone = 'Brasilia'

    config.active_record.schema_format :sql

    # config.autoload_paths += %W( #{config.root}/lib )
    config.eager_load_paths << Rails.root.join('lib')
    config.eager_load_paths << Rails.root.join('abilities')
    config.eager_load_paths << Rails.root.join('serializers')

    config.generators do |g|
        g.assets = nil
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end

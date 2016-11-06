require_relative 'boot'

require 'rails/all'
require 'csv'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sprint1
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += %W(#{config.root}/app/views/reports)
    config.autoload_paths += %W(#{config.root}/app/views/reports/activity_pdf)
    config.autoload_paths += %W(#{config.root}/app/views/reports/donor_pdf)
    config.autoload_paths += %W(#{config.root}/app/views/reports/gift_pdf)
  end
end

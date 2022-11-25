require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)




# require "rails/test_unit/railtie"
# require 'pdfkit'
# require 'shrimp'
# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
require File.expand_path('../../lib/devise/sign_in_interceptor', __FILE__)


#
# SECRETS_CONFIG = YAML.load(File.read(File.expand_path('../secrets.yml', __FILE__)))
# SECRETS_CONFIG.merge! SECRETS_CONFIG.fetch(Rails.env, {})

module Sl3
  class Application < Rails::Application

    # config.middleware.use Devise::SignInInterceptor, { :scope  => :user, :klass => 'User',
    #                                        :secret =>  SECRETS_CONFIG[Rails.env][:phantomjs_secret_token] }
    # config.middleware.use PDFKit::Middleware
    # config.middleware.use Shrimp::Middleware, :margin => '1cm', :format => 'legal'
    require "#{Rails.root}/lib/extensions.rb"
    config.colorize_logging = true
    # Enable the asset pipeline
    # config.assets.enabled = false
    config.assets.precompile += %w( normalize.css invoice_pdf.js invoice_pdf.css invoice.css registration.js registration.css .svg .eot .woff .ttf)
    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.1'

    config.to_prepare {
      Devise::SessionsController.layout "registration"
      Devise::PasswordsController.layout "registration"
	}
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.active_record.timestamped_migrations = false
    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)
    config.autoload_paths += Dir["#{config.root}/lib", "#{config.root}/lib/**/"]
    config.autoload_paths += %W[#{config.root}/lib]
    config.active_record.schema_format = :sql
    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
     config.time_zone = 'UTC'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    # rails will fallback to config.i18n.default_locale translation
    config.i18n.enforce_available_locales = true
    config.i18n.default_locale = :en
    config.i18n.fallbacks = true

    # rails will fallback to en, no matter what is set as config.i18n.default_locale
    config.i18n.fallbacks = [:en]
    # JavaScript files you want as :defaults (application.js is always included).
    # config.action_view.javascript_expansions[:defaults] = %w(jquery rails)

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password, :password_confirmation]

  end
end

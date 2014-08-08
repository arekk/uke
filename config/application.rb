require File.expand_path('../boot', __FILE__)

# Pick the frameworks you want:
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Uke
  class Application < Rails::Application

     def self.custom_config(key = nil, default = nil)
      @custom_config = YAML.load_file("#{Rails.root.to_s}/config/application.yml")[Rails.env] if @custom_config.nil?
      return @custom_config if key.nil?

      key = key.to_s
      return @custom_config.key?(key) ? @custom_config[key] : default
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en
    config.i18n.available_locales = [:en, :pl]

    config.autoload_paths << Rails.root.join('lib')

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
      :address              => custom_config(:smtp_address),
      :port                 => custom_config(:smtp_port),
      :user_name            => custom_config(:smtp_user_name),
      :password             => custom_config(:smtp_password),
      :authentication       => custom_config(:smtp_authentication),
      :enable_starttls_auto => custom_config(:smtp_enable_starttls_auto),
      :openssl_verify_mode  => 'none'
    }
  end
end

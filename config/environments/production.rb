require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Serve static files if ENV is set
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?

  # Assets
  config.assets.css_compressor = nil
  config.assets.js_compressor = nil
  config.assets.compile = false

  # Asset host
  config.asset_host = "https://chords.risensaviorministry.com"

  # Active Storage
  config.active_storage.service = :local

  # Force HTTPS (IMPORTANT)
  config.force_ssl = true

  # Logging
  config.log_level = :info
  config.log_tags = [:request_id]

  # Action Mailer (SMTP)
config.action_mailer.delivery_method = :smtp

config.action_mailer.smtp_settings = {
  address: ENV['SMTP_ADDRESS'],
  port: 587,
  user_name: ENV['SMTP_USERNAME'],
  password: ENV['SMTP_PASSWORD'],
  authentication: :login,
  enable_starttls_auto: true,
  domain: ENV['SMTP_DOMAIN'] || ENV['APP_HOST']
}

config.action_mailer.default_url_options = {
  host: ENV['APP_HOST'],
  protocol: 'https'
}

config.action_mailer.default_options = {
  from: ENV['MAIL_FROM']
}


  # Enable email error reporting (useful for debugging)
  config.action_mailer.raise_delivery_errors = true

  # I18n
  config.i18n.fallbacks = true

  # Deprecations
  config.active_support.report_deprecations = false

  # Logging format
  config.log_formatter = Logger::Formatter.new

  # Log to STDOUT (Docker friendly)
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new($stdout)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations
  config.active_record.dump_schema_after_migration = false
end

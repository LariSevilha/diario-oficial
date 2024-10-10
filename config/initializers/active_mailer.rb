# frozen_string_literal: true

Rails.application.configure do
  config.action_mailer.default_url_options = { host: ENV['DOMAIN'] }
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address: ENV['SMTP_ADDRESS'],
    port: ENV['SMTP_PORT'],
    domain: ENV['SMTP_DOMAIN'],
    user_name: ENV['SMTP_USER_NAME'],
    password: ENV['SMTP_PASSWORD'],
    authentication: 'login',
    enable_starttls_auto: false,
    openssl_verify_mode: 'none'
  }

  config.action_mailer.perform_deliveries = true if Rails.env.development?
end

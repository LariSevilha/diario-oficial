# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'

gem 'audited'
gem 'bootsnap', require: false
gem 'cancancan', '~> 3.0'
gem 'carrierwave', '>= 3.0.0.beta', '< 4.0'
gem 'carrierwave-ftp', '~> 0.4.1', require: 'carrierwave/storage/sftp', git: 'https://github.com/agencia-w3/carrierwave-ftp'
gem 'combine_pdf'
gem 'cssbundling-rails'
gem 'devise', '~> 4.9', '>= 4.9.2'
gem 'devise-i18n', '~> 1.11'
gem 'diff-lcs'
gem 'diffy'
gem 'email_validator'
gem 'friendly_id', '~> 5.5'
gem 'jsbundling-rails'
gem 'kaminari'
gem 'meta-tags', '~> 2.18'
gem 'pdf-reader'
gem 'pg', '~> 1.1'
gem 'pg_search', '~> 2.3', '>= 2.3.6'
gem 'prawn'
gem 'nokogiri'
gem 'puma', '~> 5.0'
gem 'rails', '~> 7.0.4', '>= 7.0.4.3'
gem 'rails-admin-scaffold', '~> 0.1.0'
gem 'recaptcha', '~> 5.14'
gem 'redis', '~> 5.0', '>= 5.0.6'
gem 'rubocop', '~> 1.65', require: false
gem 'rubocop-rails', require: false
gem 'sanitize'
gem 'sassc-rails'
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'sitemap_generator', '~> 6.3'
gem 'sprockets-rails'
gem 'htmlentities'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'whenever', require: false
gem 'wicked_pdf'
gem 'youtube_rails'

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'erb-formatter', '~> 0.4.3'
  gem 'faker'
  gem 'hotwire-livereload', '~> 1.2', '>= 1.2.3'
  gem 'htmlbeautifier'
  gem 'pry-byebug', '~> 3.10', '>= 3.10.1'
  gem 'rspec-rails'
end

group :development do
  gem 'mina', '0.3.8'
  gem 'web-console'
end

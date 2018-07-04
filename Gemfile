source 'https://rubygems.org'

gem 'figaro', '~> 1.1.0'
gem 'jbuilder'
gem 'pg', '~> 1.0.0'
gem 'rails', '~> 5.0.0'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'sass-rails'
gem 'simpleidn', '0.0.7' # For Punycode
gem 'SyslogLogger', '2.0', require: 'syslog/logger'
gem 'uglifier'

group :development do
  gem 'puma'
end

group :development, :test do
  gem 'pry'
  gem 'unicorn'

  gem 'capybara'
  gem 'mina', '~> 0.3.8'
  gem 'webmock'
end

group :test do
  gem 'simplecov', require: false
end

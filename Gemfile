source 'http://rubygems.org'

gem 'sinatra'
gem 'activerecord', '~> 6.0.0', :require => 'active_record'
gem 'sinatra-activerecord', :require => 'sinatra/activerecord'
gem 'rake'
gem 'require_all'
gem 'thin', '~>1.8'
gem 'bcrypt'
gem "tux"
gem 'sinatra-flash'

gem 'rest-client', '~> 2.1'
gem 'json', '~> 2.3', '>= 2.3.1'
gem 'dotenv', '~> 2.7', '>= 2.7.6'

group :development, :test do
  gem 'sqlite3'
  gem 'shotgun'
  gem 'pry'
  gem 'rspec'
  gem 'capybara'
  gem 'rack-test'
  gem 'database_cleaner'
end

group :production do
  gem 'pg'
  gem 'sqlite3'
end
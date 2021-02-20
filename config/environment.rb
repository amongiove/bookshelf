require 'sinatra'
require 'active_record'
require 'require_all'

configure :development do
    ENV['SINATRA_ENV'] ||= "development"

    require 'bundler/setup'
    Bundler.require(:default, ENV['SINATRA_ENV'])

    ActiveRecord::Base.establish_connection(
        :adapter => "sqlite3",
        :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
      )
end

require_all 'app'

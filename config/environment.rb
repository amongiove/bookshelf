require 'sinatra'
require 'active_record'
require 'require_all'

require 'dotenv'
    Dotenv.load('file1.env', 'file2.env')

configure :development do
    ENV['SINATRA_ENV'] ||= "development"

    require 'bundler/setup'
    Bundler.require(:default, ENV['SINATRA_ENV'])

    ActiveRecord::Base.establish_connection(
        :adapter => "sqlite3",
        :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
    )
end

configure :production do
    ENV['SINATRA_ENV'] ||= "production"

    require 'bundler/setup'
    Bundler.require(:default, ENV['SINATRA_ENV'])

    ActiveRecord::Base.establish_connection(
        :adapter => "postgresql",
        :database => "db/#{ENV['SINATRA_ENV']}.postgresql"
    )
end

require_all 'app'

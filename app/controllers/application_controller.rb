require './config/environment'
require 'sinatra/base'
require 'sinatra/flash'
require 'dotenv/load'
require 'rest-client'
require 'json'

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions 
    set :session_secret, "secret"
    #need to change session_secret
    set :public_folder, 'public'
    set :views, 'app/views'
    register Sinatra::Flash
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

  get '/' do 
    redirect to('/login')
  end

  not_found do
    status 404
    'not found'
    erb :'/404'
  end

end
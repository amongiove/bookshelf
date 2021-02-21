require './config/environment'
require 'sinatra/base'
require 'sinatra/flash'

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions 
    set :session_secret, "secret"
    #need to change session_secret
    set :public_folder, 'public'
    set :views, 'app/views'
    register Sinatra::Flash
  end

  get '/' do 
    erb :'index'
  end

end
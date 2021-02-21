require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions 
    set :session_secret, "secret"
    #need to change session_secret
    set :public_folder, 'public'
    set :views, 'app/views'
    use Rack::Flash
  end


end
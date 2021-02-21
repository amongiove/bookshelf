class UsersController < ApplicationController

    get '/login' do
        erb :'users/login'
    end

    get '/signup' do
        erb :'users/signup'
    end

    post '/signup' do
        #check that UN and email are unique
        #create new user
        #log user in
        #redirect to user home
        puts "post signup"
    end
end
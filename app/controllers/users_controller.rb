class UsersController < ApplicationController

    get '/login' do
        erb :'users/login'
    end

    get '/signup' do
        erb :'users/signup'
    end

    post '/signup' do
        if params[:username].empty? || params[:email].empty? || params[:password].empty?
            flash[:message] = "Please fill in all available fields."
            redirect to("/signup")
        elsif 
            if User.find_by(:username => params[:username]) != nil 
                flash[:message] = "That username is already in use."
                redirect to("/signup")
            elsif
                User.find_by(:email => params[:email]) != nil
                    flash[:message] = "That email is already in use."
                    redirect to("/signup") 
            else  
                @user = User.create(username: params[:username], email: params[:email], password_digest: params[:password])
                session['user_id'] = @user.id  
            end
            @user.save
        end
        # redirect to(login and home page)
    end

    get '/login' do
        erb :'login'
    end

    post '/login' do
        puts "POST LOGIN"
    end

end
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
        # if logged_in?
        #     redirect to("/home/:username_slug")
        # else
            erb :'login'
        # end
    end

    post '/login' do
        @user = User.find_by(:username => params[:username], :password_digest => params[:password])
        if @user != nil
            session['user_id'] = @user.id
            redirect to('/home/:username_slug')
        else
            flash[:message] = "Incorrect username and/or password."
            redirect to('/')
        end
    end

end
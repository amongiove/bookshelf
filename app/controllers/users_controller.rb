class UsersController < ApplicationController

    get '/signup' do
        erb :'users/signup'
    end

    post '/signup' do
        if User.find_by(:username => params[:username].downcase) != nil 
            flash[:message] = "That username is already in use."
            redirect to("/signup")
        elsif
            User.find_by(:email => params[:email].downcase) != nil
                flash[:message] = "That email is already in use."
                redirect to("/signup") 
        elsif
            params[:password] != params[:reenter_password]
            flash[:message] = "Passwords do not match."
            redirect to("/signup") 
        else  
            @user = User.create(username: params[:username].downcase, email: params[:email].downcase, password: params[:password])
            session['user_id'] = @user.id 
            @user.save 
            session['user_id'] = @user.id
            redirect to('/home')
        end 
    end

    get '/login' do
        if logged_in?
            redirect to("/home")
        else
            erb :'users/login'
        end
    end

    post '/login' do
        @user = User.find_by(:username => params[:username]) 
        if @user  && @user.authenticate(params[:password])
            session[:user_id] = @user.id
            redirect to("/home")
        else
            flash[:message] = "Incorrect username and/or password."
            redirect to('/login')
        end
    end

    get '/logout' do
        session.clear
        redirect to('/login')
    end

    get '/home' do
        if logged_in?
            @user = User.find_by_id(session['user_id'])
            @books = @user.books
            @user_books = @user.user_books
            erb :'users/user_home'
        else
            flash[:message] = "You must be logged in to view this page."
            redirect to("/login")
        end
    end

    get '/users' do
        if logged_in?
            @users = User.all
            erb :'users/users'
        else
            flash[:message] = "You must be logged in to view this page."
            redirect to('/login')
        end
    end

    get '/users/:slug' do
        if logged_in?
            @user = User.find_by_slug(params[:slug])
            if @user != nil
                @books = Book.all
                @user_books = @user.user_books
                erb :'users/show'
            else
                erb :'/404'
            end
        else
            flash[:message] = "You must be logged in to view this page."
            redirect to('/login')
        end
    end

end
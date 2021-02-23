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
                @user = User.create(username: params[:username].downcase, email: params[:email].downcase, password_digest: params[:password])
                session['user_id'] = @user.id  
            end
            @user.save
        end
        redirect to('/home')
    end

    get '/login' do
        if logged_in?
            redirect to("/home")
        else
            erb :'login'
        end
    end

    post '/login' do
        @user = User.find_by(:username => params[:username], :password_digest => params[:password])
        if @user != nil
            session['user_id'] = @user.id
        else
            flash[:message] = "Incorrect username and/or password."
            redirect to('/')
        end
        redirect to("/home")
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
            redirect to("/")
        end
    end

    get '/users' do
        if logged_in?
            @users = User.all
            erb :'users/users'
        else
            flash[:message] = "You need to be logged in to see that."
            redirect to('/')
        end
    end

    get '/users/:slug' do
        @user = User.find_by_slug(params[:slug])
        @books = Book.all
        @user_books = @user.user_books
        erb :'users/show'
    end

end
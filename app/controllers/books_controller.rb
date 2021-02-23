class BooksController < ApplicationController
    
    get '/books' do
        erb :'books/books'
    end

    get '/books/new' do
        @genres = Genre.all
        erb :'books/new'
    end

    post '/books/new' do
        @book = Book.find_by(:title => params[:title].downcase, :author => params[:author].downcase)
        if @book != nil
            flash[:message] = "This book already exists in our database."
            redirect to("/books/#{@book.slug}")
        else
            if params[:title].empty? || params[:author].empty?
                flash[:message] = "Please fill-in all specified fields."
                redirect to('/books/new') 
            else 
                @book = Book.create(:title => params[:title].downcase, :author => params[:author].downcase, :created_by_id => current_user.id)
                unless params[:book][:genre_ids].empty?
                    params[:book][:genre_ids].each do |genre|
                        @book.genres << Genre.find_by_id(genre)
                    end
                    @book.users << current_user
                end
                @userbook = UserBook.find_by(:user_id => current_user.id, :book_id => @book.id)
                @userbook.read = params[:"yes_no"]
                @userbook.save
            end
            @book.save
        end
        redirect to("/books/#{@book.slug}")
    end

    get '/books/:slug' do
        @book = Book.find_by_slug(params[:slug])
        erb :'books/show'
    end

    delete '/books/:slug/delete' do
        if logged_in?
            @book = Book.find_by_slug(params[:slug])
            if @book.user_ids.include?(current_user.id)
                @book.users.delete(User.find_by_id(current_user.id))
                flash[:message] = "Book removed from Bookshelf"
                redirect to("/home")
            else
                flash[:message] = "Please login to edit a list."
                redirect to("/")
            end
        end
    end

    get '/books/:slug/review' do
        @book = Book.find_by_slug(params[:slug])
        @user = current_user
        @review = Review.find_by(:book_id => @book.id, :user_id => @user.id)
        if @review != nil
            flash[:message] = "Oops! It looks like you have already reviewed this book."
            redirect to("/books/#{@book.slug}")
        else
            erb :'books/review'
        end
    end

    post '/books/:slug/review' do
        @book = Book.find_by_slug(params[:slug])
        if params[:review].empty? || params[:rating].empty?
            flash[:message] = "Please fill-in all available fields"
            redirect to("/books/#{@book.slug}/review")
        else
            @review = Review.create(:review => params[:review], :rating_value => params[:rating], :book_id => @book.id, :user_id => current_user.id)
            @userbook = UserBook.find_or_create_by(:user_id => current_user.id, :book_id => @book.id)
            @userbook.read = true
        end
        @userbook.save
        @review.save
        redirect to('/home')
    end

    get '/books/:slug/add' do
    end
end
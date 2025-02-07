class BooksController < ApplicationController
    
    get '/books' do
        if logged_in?
            @books = Book.all
            erb :'books/books'
        else
            redirect to("/")
        end
    end

    get '/books/new' do
        if logged_in?
            @genres = Genre.all
            erb :'books/new'
        else
            redirect to("/")
        end
    end

    post '/books/new' do
        if logged_in?
            @book = Book.find_by(:title => params[:title].downcase, :author => params[:author].downcase)
            if @book != nil
                flash[:message] = "This book already exists in our database."
                redirect to("/books/#{@book.slug}")
            elsif params[:title].empty? || params[:author].empty?
                    flash[:message] = "Please fill in all specified fields."
                    redirect to('/books/new') 
            elsif !params[:book] || !params[:book][:genre_ids]
                flash[:message] = "Please specify at least one genre."
                redirect to('/books/new') 
            elsif !params[:yes_no]
                flash[:message] = "Please specify if you have or have not already read this book."
                redirect to('/books/new') 
            else 
                @book = Book.create(:title => params[:title].downcase, :author => params[:author].downcase, :created_by_id => current_user.id)
                params[:book][:genre_ids].each do |genre|
                    @book.genres << Genre.find_by_id(genre)
                end
                @book.users << current_user
                @userbook = UserBook.find_by(:user_id => current_user.id, :book_id => @book.id)
                @userbook.read = params[:"yes_no"]
                @userbook.save
                @book.save
                redirect to("/books/#{@book.slug}")
            end
        else
            redirect to("/")
        end
    end

    get '/books/:slug' do
        if logged_in?
            @book = Book.find_by_slug(params[:slug])
            if @book != nil
                erb :'books/show'
            else
                erb :'/404'
            end
        else
            redirect to("/")
        end
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
        else 
            redirect to ("/")
        end
    end

    get '/books/:slug/review' do
        if logged_in?
            @book = Book.find_by_slug(params[:slug])
            @user = current_user
            @review = Review.find_by(:book_id => @book.id, :user_id => @user.id)
            erb :'books/review'
        else
            redirect to("/")
        end
    end

    post '/books/:slug/review' do
        if logged_in?
            @book = Book.find_by_slug(params[:slug])
            @user = current_user
            @review = Review.find_by(:book_id => @book.id, :user_id => @user.id)
            if @review != nil
                flash[:message] = "Oops! It looks like you have already reviewed this book."
                redirect to("/books/#{@book.slug}")
            elsif params[:review].empty? || params[:rating] == nil
                flash[:message] = "Please fill-in all available fields"
                redirect to("/books/#{@book.slug}/review")
            else
                @review = Review.create(:review => params[:review], :rating_value => params[:rating], :book_id => @book.id, :user_id => current_user.id)
                @userbook = UserBook.find_or_create_by(:user_id => current_user.id, :book_id => @book.id)
                @userbook.read = true
                @userbook.save
                @review.save
                redirect to('/home')
            end
        else
            redirect to("/")
        end
    end

    get '/books/:slug/review/edit' do
        if logged_in?
            @book = Book.find_by_slug(params[:slug])
            @user = current_user
            @review = Review.find_by(:book_id => @book.id, :user_id => @user.id)
            erb :'/books/edit_review'
        else
            redirect to("/")
        end
    end

    patch '/books/:slug/review/edit' do
        if logged_in?
            @book = Book.find_by_slug(params[:slug])
            @user = current_user
            @review = Review.find_by(:book_id => @book.id, :user_id => @user.id)
            if params[:review].empty? || params[:rating] == nil
                flash[:message] = "Please fill-in all available fields"
                redirect to("/books/#{@book.slug}/review/edit")
            else
                @review.update(:review => params[:review], :rating_value => params[:rating])
                redirect to("/books/#{@book.slug}")
            end
        else
            flash[:message] = "You must be logged in to edit a review."
            redirect to("/login") 
        end
    end

    get '/books/:slug/add' do
        if logged_in?
            @book = Book.find_by_slug(params[:slug])
            if UserBook.find_by(:book_id => @book.id, :user_id => current_user.id) != nil
                flash[:message] = "Oops! It looks like this book is already on your BookShelf."
                redirect to('/home')
            else
                erb :'/books/add'
            end
        else
            flash[:message] = "You must be logged into add to a list."
            redirect to('/login')
        end
    end
    
    post '/books/:slug/add' do
        @book = Book.find_by_slug(params[:slug])
        @book.users << current_user    
        @book.save
        @userbook = UserBook.find_by(:user_id => current_user.id, :book_id => @book.id)
        @userbook.read = params[:"read?"]
        @userbook.save
        redirect to('/home')
    end  

    post '/books/:slug/read' do
        @book = Book.find_by_slug(params[:slug])
        @userbook = UserBook.find_by(:user_id => current_user.id, :book_id => @book.id)
        @userbook.read = true
        @userbook.save
        redirect to("/books/#{@book.slug}")   
    end

    get '/books-by-rating' do
        if logged_in?
            @books = Book.all
            @reviews = Review.all

            @average_ratings = {}
            @books.each do |book|
                @ratings = []
                book.reviews.each do |reivew|
                    @ratings << reivew.rating_value
                end
            
                if book.reviews.empty?
                    @average_ratings[book.id] = 0
                else
                    @average_ratings[book.id] = ((@ratings.sum)/(@ratings.size).to_f)
                end
            end
            @sorted_averages = @average_ratings.sort_by{|_key, value| value}.reverse
            erb :'books/rating'
        else
            redirect to("/")
        end
    end

    get '/books-by-genre' do
        if logged_in?
            @genres = Genre.all
            erb :'books/genre'
        else
            redirect to("/")
        end
    end
    
    post '/books-by-genre' do
        if Genre.find_by_id(params[:genre_id]) != nil
            @books = Book.all
            @genre = Genre.find_by_id(params[:genre_id])
            if @genre.books.empty?
                flash[:message] = "Sorry, we couldn't find any books in our library that belong to this genre. Select another genre to continue."
                redirect to("/books-by-genre")
            end
            erb :'books/show_genre'
        else
            flash[:message] = "Please select a genre to continue to books."
            redirect to("/books-by-genre")
        end
    end

    post '/recommendations' do 
        if logged_in?
            if Genre.find_by(:category_id => params[:genre_category_id]) != nil
                category_id = params[:genre_category_id]
                @genre = Genre.find_by(:category_id => category_id)
                penguin_data = PenguinApi.get_books(category_id)
                @books = TransformData.get_book_info(penguin_data)
                erb :'/books/show_recs'
            else
                flash[:message] = "Please select a genre to continue to recommendations."
                redirect to("/books")
            end
        else
            redirect to("/")
        end
    end

    post '/recommendations/add' do
        if logged_in?
            @book = Book.find_by(:title => params[:book][":title"].downcase, :author => params[:book][":author"].downcase)
            if @book != nil
                flash[:message] = "This book already exists in our database."
                redirect to("/books/#{@book.slug}")
            else
                @book = Book.create(:title => params[:book][":title"].downcase, :author => params[:book][":author"].downcase, :created_by_id => current_user.id)
                @book.genres << Genre.find_by_id(params[:book][":genre"])
                @book.users << current_user
                @book.save
                @userbook = UserBook.find_by(:user_id => current_user.id, :book_id => @book.id)
                @userbook.read = false
                @userbook.save
            end
            redirect to("/books/#{@book.slug}")
        else
            redirect to("/")
        end
    end
end
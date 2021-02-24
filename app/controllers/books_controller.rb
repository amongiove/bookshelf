class BooksController < ApplicationController
    
    get '/books' do
        @books = Book.all
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

    # get '/books/:slug/read' do
    #     #can i make this a pop up window vs. own page??
    #     @book = Book.find_by_slug(params[:slug])
    #     erb :'/books/read'  
    # end

    post '/books/:slug/read' do
        @book = Book.find_by_slug(params[:slug])
        @userbook = UserBook.find_by(:user_id => current_user.id, :book_id => @book.id)
        @userbook.read = true
        @userbook.save
        redirect to("/books/#{@book.slug}")   
    end

    get '/books-by-rating' do
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
    end

    get '/books-by-genre' do
        erb :'books/genre'
    end
    
    post '/books-by-genre' do
        @books = Book.all
        @genre = Genre.find_by_id(params[:genre_id])
        erb :'books/show_genre'
    end
end
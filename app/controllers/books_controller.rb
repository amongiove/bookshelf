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
        erb :'books/show'
    end
end
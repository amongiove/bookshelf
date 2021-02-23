class BooksController < ApplicationController
    
    get '/books' do
        erb :'books/books'
    end

    get '/books/new' do
        erb :'books/new'
    end
end
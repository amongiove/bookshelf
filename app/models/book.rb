class Book < ActiveRecord::Base
    belongs_to :author
    has_many :user_books
    has_many :users, through: :user_books
    has_many :book_genres
    has_many :genres, through: :book_genres
    has_many :reviews
    
end

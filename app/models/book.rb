class Book < ActiveRecord::Base
    has_many :user_books
    has_many :users, through: :user_books
    has_many :book_genres
    has_many :genres, through: :book_genres
    has_many :reviews

    def slug
        self.username.downcase.split.join('-')
    end
    
    def self.find_by_slug(slug)
        Book.all.find{|book| book.slug == slug}
    end
    
end

class User < ActiveRecord::Base
    has secure_password
    has_many :user_books
    has_many :books, :through :user_books
    has_many :reviews
end

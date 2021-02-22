class User < ActiveRecord::Base
    has_secure_password
    has_many :user_books
    has_many :books, through: :user_books
    has_many :reviews

    def slug
        self.username.downcase.split.join('-')
    end
    
    def self.find_by_slug(slug)
        User.all.find{|user| user.slug == slug}
    end

end

require 'json'

class TransformData

  def self.get_book_info(penguin_data)
    books = penguin_data["data"]["titles"]
    @books = []
    books.each do |book|
        book_data = {}
        book_data[:title]= book["title"]
        book_data[:author] = book["author"]
        @books << book_data
    end
    @books
  end


end

require 'json'

class TransformData

  def self.get_book_info(books)
    books[:data][:titles].each do |book|
        book_data = {}
        book_data[:title]=book["title"]
        book_data[:author] = book["author"]
    end
    books[:params][:catId] = category_id
    book.genres << Genre.find_by(:category_id => category_id)
    book["created_by_id"] = 0 
  end


end

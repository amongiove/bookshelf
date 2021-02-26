class PenguinApi

    def self.get_books
        url = "https://api.spoonacular.com/recipes/findByIngredients?apiKey=#{ENV['API_KEY']}&ingredients=" + ingredients
        response = RestClient.get(url, headers={})
        books = JSON.parse(response)
    end

end
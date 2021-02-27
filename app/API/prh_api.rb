class PenguinApi

    def self.get_books(category_id)
        url = "https://api.penguinrandomhouse.com/resources/v2/title/domains/PRH.US/titles?catId=" + category_id + "&sort=random&api_key=#{ENV['API_KEY']}"
        response = RestClient.get(url, headers={})
        books = JSON.parse(response)
    end

end
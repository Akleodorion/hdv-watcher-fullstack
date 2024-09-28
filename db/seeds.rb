# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Faire la requête au serveur heroku.
url = "https://hdv-watcher-3be496b8731a.herokuapp.com/items"
json_data = URI.open(url).read

items_data = JSON.parse(json_data, symbolize_names: true)

items_data.each do |item|
  puts item[:name]
  item = Item.new(name: item[:name], img_url: item[:img_url], ressource_type: item[:ressource_type])


  item.unit_price_info["price_list"] = filter_zero_and_doubles(item["unit_price"])
  item.tenth_price_info["price_list"] = item["tenth_price"]
  item.hundred_price_info["price_list"] = item["hundred_price"]
end


def filter_zero_and_doubles(prices,scrap_dates)
  filtered_array = []
  prices.each_with_index do |price,i|
    if filtered_array.last != a && a != 0
      filtered_array <<  { price: price, scrap_date:}
    end
  end
  return filtered_array
end
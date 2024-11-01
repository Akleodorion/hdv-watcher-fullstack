# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Item.destroy_all



seeds_info_url = "https://hdv-watcher-3be496b8731a.herokuapp.com/items/scrap_info"
seeds_items_url = "https://hdv-watcher-3be496b8731a.herokuapp.com/items"

json_batch_data = URI.open(seeds_info_url).read
batch_data = JSON.parse(json_batch_data, symbolize_names: true)

items_to_import = []
prices_to_import = []
items_data = []
request_number = batch_data[:batch_count].to_i

request_number.times do |n|
  puts "batch: n° #{n}"
  params = { batch_index: n }
  uri = URI(seeds_items_url)
  uri.query = URI.encode_www_form(params)
  json_items_data = URI.open(uri).read
  items_temp_data = JSON.parse(json_items_data, symbolize_names: true)
  items_data << items_temp_data
end

items_data.flatten.each do |item_data|
  items_to_import << Item.new(name: item_data[:name], img_url: item_data[:img_url], ressource_type: item_data[:ressource_type])
end
p "Création des items"
Item.import(items_to_import)

price_history_to_import = Item.all.map do |item|
  [
    PriceHistory.new(price_type: "unit", item_id: item.id, is_worth: false),
    PriceHistory.new(price_type: "tenth", item_id: item.id, is_worth: false),
    PriceHistory.new(price_type: "hundred", item_id: item.id, is_worth: false)
  ]
end

p "Création des prices history"
PriceHistory.import(price_history_to_import.flatten)

items_data.flatten.each do |item_data|
  phs = PriceHistory.joins(:item).select("id").where( item: { name: item_data[:name] })
  
  item_data[:unit_price].each_with_index do |value, index|
    date = item_data[:scrap_date][index]
    prices_to_import << {value: value, date: date, price_history_id: phs[0].id}
    prices_to_import << {value: item_data[:tenth_price][index], date: date, price_history_id: phs[1].id}
    prices_to_import << {value: item_data[:tenth_price][index], date: date, price_history_id: phs[2].id}
    
  end
end
p "Il y'a #{prices_to_import.length} prix à stocker"
batch_size = 50000
puts "Il y a #{prices_to_import.length / batch_size} batch."
prices_to_import.each_slice(batch_size).with_index do |batch, index|
  p "Création des prices pour un batch de #{batch.size} - batch n°: #{index}"
  Price.insert_all(batch)
end

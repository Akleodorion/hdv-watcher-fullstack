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

def filter_zero_and_doubles(prices,scrap_dates)
  filtered_array = []
  prices.each_with_index do |price,i|
    if filtered_array.last != price.to_i && price.to_i != 0
      filtered_array <<  { price: price.to_i, scrap_date: scrap_dates[i]}
    end
  end
  return filtered_array
end

def calculate_median_price(array)
  array.sort!
  return 0 if array.empty?
  middle = (array.count / 2)
  array.count % 2 == 1 ? array[middle] : (array[middle - 1] + array[middle])/2
end

def calculate_capital_gain(median_price, current_price)
  return 0 if current_price.nil?
  
  return median_price - ( current_price + (median_price * 0.02))
end

def is_worth?(median_price, current_price)
  return 0 if current_price.nil?
  return median_price > ( current_price + (median_price * 0.02)) && current_price != 0
end

# # Faire la requête au serveur heroku.
# url = "https://hdv-watcher-3be496b8731a.herokuapp.com/items"
# json_data = URI.open(url).read

# items_data = JSON.parse(json_data, symbolize_names: true)

def process_price_info(item, price_info_key, price_data, scrap_date)
  item[price_info_key][:price_list] = filter_zero_and_doubles(price_data, scrap_date)
  prices = item[price_info_key][:price_list].map { |price| price[:price] }

  item[price_info_key][:median_price] = calculate_median_price(prices)
  
  unless item[price_info_key][:price_list].empty?
    item[price_info_key][:current_price] = item[price_info_key][:price_list].last[:price]
    item[price_info_key][:capital_gain] = calculate_capital_gain(item[price_info_key][:median_price], item[price_info_key][:current_price])
    item[price_info_key][:is_worth] = is_worth?(item[price_info_key][:median_price], item[price_info_key][:current_price])
  end
end

def process_item_data(item_data)
  puts item_data[:name]
    
    item = Item.new(
      name: item_data[:name],
      img_url: item_data[:img_url],
      ressource_type: item_data[:ressource_type]
    )
  
    process_price_info(item, :unit_price_info, item_data[:unit_price].to_i, item_data[:scrap_date])
    process_price_info(item, :tenth_price_info, item_data[:tenth_price].to_i, item_data[:scrap_date])
    process_price_info(item, :hundred_price_info, item_data[:hundred_price].to_i, item_data[:scrap_date])
  
    item.save!
end



seeds_info_url = "https://hdv-watcher-3be496b8731a.herokuapp.com/items/scrap_info"
seeds_items_url = "https://hdv-watcher-3be496b8731a.herokuapp.com/items"

json_batch_data = URI.open(seeds_info_url).read
batch_data = JSON.parse(json_batch_data, symbolize_names: true)

# Nombre de batch d'item à récupérer
request_number = batch_data[:batch_count].to_i


request_number.times do |n|

  puts "batch: n° #{n}"
  params = {batch_index: n}
  p params
  uri = URI(seeds_items_url)
  uri.query = URI.encode_www_form(params)
  p uri.query
  json_items_data = URI.open(uri).read
  items_data = JSON.parse(json_items_data, symbolize_names: true)

  items_data.each do |item_data|
    puts item_data[:name]
    
    item = Item.new(
      name: item_data[:name],
      img_url: item_data[:img_url],
      ressource_type: item_data[:ressource_type]
    )
  
    process_price_info(item, :unit_price_info, item_data[:unit_price], item_data[:scrap_date])
    process_price_info(item, :tenth_price_info, item_data[:tenth_price], item_data[:scrap_date])
    process_price_info(item, :hundred_price_info, item_data[:hundred_price], item_data[:scrap_date])
  
    item.save!
  end
end

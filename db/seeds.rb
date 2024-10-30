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

request_number = batch_data[:batch_count].to_i

request_number.times do |n|
  puts "batch: n° #{n}"
  params = { batch_index: n }
  uri = URI(seeds_items_url)
  uri.query = URI.encode_www_form(params)
  json_items_data = URI.open(uri).read
  items_data = JSON.parse(json_items_data, symbolize_names: true)

  items_data.each do |item_data|
    puts item_data[:name]
    
    item = Item.create!(
      name: item_data[:name],
      img_url: item_data[:img_url],
      ressource_type: item_data[:ressource_type]
    )

    # Trouver ou créer les PriceHistories
    price_histories = {
      unit: item.price_histories.find_or_create_by!(price_type: 0),
      tenth: item.price_histories.find_or_create_by!(price_type: 1),
      hundred: item.price_histories.find_or_create_by!(price_type: 2)
    }

    # Préparer les données pour les prix en masse
    prices_data = []
    num = item_data[:unit_price].count
    num.times do |i|
      prices_data << { value: item_data[:unit_price][i], date: item_data[:scrap_date][i], price_history_id: price_histories[:unit].id }
      prices_data << { value: item_data[:tenth_price][i], date: item_data[:scrap_date][i], price_history_id: price_histories[:tenth].id }
      prices_data << { value: item_data[:hundred_price][i], date: item_data[:scrap_date][i], price_history_id: price_histories[:hundred].id }
    end

    # Insérer tous les prix en une seule requête
    Price.insert_all(prices_data)

    # Mettre à jour les PriceHistories
    price_histories.values.each(&:update_price_history)
  end
end

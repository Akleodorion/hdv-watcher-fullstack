class API::V1::SeedsController < ApplicationController

  # Ajout d'items en base de donnés.
  def populate
    price_to_import = []
    items_data = JSON.parse(request.body.read, symbolize_names: true)

    items_data.each do |item_data|
      item_created = Item.create!(name: item_data[:name], img_url: item_data[:img_url], ressource_type: item_data[:ressource_type])
      ph_ids = item_created.price_histories.ids

      item_data[:unit_price].each_with_index do |price, index|
        date = item_data[:scrap_date][index]
        price_to_import << Price.new(value: price, date: date, price_history_id: ph_ids[0])
        price_to_import << Price.new(value: item_data[:tenth_price], date: date, price_history_id: ph_ids[1])
        price_to_import << Price.new(value: item_data[:hundred_price], date: date, price_history_id: ph_ids[2])
      end
    end

    Price.import(price_to_import)    
  end

  def infos
  end

  private

  def populate_params
    params.permit(:items)
  end
end
class API::V1::ScrapsController < ApplicationController

  def entry
    items_data = JSON.parse(request.body.read, symbolize_names: true)
    date = Time.now
    prices_to_import = []

    items_data.each do |item_data|
      item = Item.find_or_initialize_by(name: item_data[:name])
      
      if !item.persisted?
        item.img_url = item_data[:img_url]
        item.ressource_type = item_data[:ressource_type]
        item.save
      end

      if item.price_histories.count == 3
        phs = item.price_histories
        prices_to_import << Price.new(value: item_data[:unit_price], date: date, price_history_id: phs[0].id)
        prices_to_import << Price.new(value: item_data[:tenth_price], date: date, price_history_id: phs[1].id)
        prices_to_import << Price.new(value: item_data[:hundred_price], date: date, price_history_id: phs[2].id)
      end
    end

    Price.import(prices_to_import)
  end

  def infos
  end

  private

  def entry_params
    params.permit(:name, :img_rl, :ressource_type, :unit_price, :tenth_price, :hundred_price)
  end
end
class Api::V1::ItemsController < ApplicationController

  def scrap
  # on recoit une liste d'item depuis la requête.
  items_data = JSON.parse(request.body.read, symbolize_names: true)
  time = Time.now

  items_data.flatten.each do |item_data|
    append_or_create(item_data, time).save
  end
  render json: { message: 'Seed successful'}, status: :ok
  end

  def paginated_item;end

  private

  def append_or_create(item_data, time)
    item = Item.find_or_initialize_by(name: item_data[:name].downcase)

    item = if item.persisted?
      append_item(item,item_data,time).save
    else
      create_item(item,item_data,time)
    end
  end

  def append_item(item, item_data, time)
    append(item.unit_price_info, item_data[:unit_price], time)
    append(item.tenth_price_info, item_data[:tenth_price], time)
    append(item.hundred_price_info, item_data[:hundred_price], time)
 
  end

  def append(item_price_info, item_data_price, time)
    return unless item_price_info[:price_list][:price].last != item_data_price
    item_price_info[:price_list] << { price: item_data[:price], scrap_date: time }
    price_list = []
    item_price_info[:price_list].each do |price|
      price_list << price[:price]
    end
    item_price_info[:median_price] = calculate_median_price(price_list)
    item_price_info[:capital_gain] = calculate_capital_gain(item_price_info)
    item_price_info[:is_worth] = isWorth?(item_price_info)
  end

  def isWorth?(item_price_info)
    item_price_info[:median_price] > ( item_price_info[:price_list].last[:price] + item_price_info[:median_price] * 0.02 )
  end

  def calculate_capital_gain(item_price_info)
   item_price_info[:median_price] - (item_price_info[:price_list].last[:price] + item_price_info[:median_price] * 0.02 )
  end

  def calculate_median_price(price_list)
    return calculate_median(sort_array(filter_zero_and_doubles(price_list)))
  end


  def filter_zero_and_doubles(price_list)
    filtered_array = []
    price_list.each do |price|
      return if filtered_array.last == price || price == 0
      filtered_array << price
    end
    filtered_array
  end

  def sort_array(array)
    array.sort { |a,b| a <=> b}
  end

  def calculate_median(array)
    return 0 if array.empty?
    middle = (array.count / 2)
    array.count % 2 == 1 ? array[middle] : (array[middle - 1] + array[middle])/2
  end
end

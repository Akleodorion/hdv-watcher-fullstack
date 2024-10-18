class Api::V1::ItemsController < ApplicationController

  def scrap_entry
  # on recoit une liste d'item depuis la requête.
  items_data = JSON.parse(request.body.read, symbolize_names: true)
  time = Time.now

  items_data.flatten.each do |item_data|
    append_or_create(item_data, time).save
  end
  render json: { message: 'Seed successful'}, status: :ok
  end

  def scrap_info;
  end

  def index
    items_count = Item.all.count
    priceType = paginated_items_params[:price_type]
    batch_index = paginated_items_params[:batch_index].to_i
    batch_size = paginated_items_params[:batch_size].to_i
    number_of_baches = items_count.remainder(batch_size) == 0 ? (items_count / batch_size) : ( items_count / batch_size) + 1
    items =
    Item.where(ressource_type: RessourceTypes.types)
      .where("unit_price_info->>'is_worth' = 'true'")
      .order(Arel.sql("CAST(unit_price_info->>'capital_gain' AS FLOAT) DESC"))
      .limit(batch_size)
      .offset( batch_index * batch_size)
    
    # formated_items = [] 
    # items.each do |item|
    #   formated_items << {
    #   name: item[:name],
    #   img_url: item[:img_url],
    #   ressource_type: item[:ressource_type],
    #   current_price: item["unit_price_info"][:price_list].last[:price],
    #   median_price: item["unit_price_info"][:median_price],
    #   capital_gain: item["unit_price_info"][:capital_gain]
    #   }
    # end
    
    # response = {
    #   "items": formated_items,
    #   "batch_size": number_of_baches,
    # }

    render json: items
  end


  def show
  item = Item.find(id: item_prices_params[:item_id])
  render json: item
  end


  private

  def paginated_items_params
    params.permit(:batch_index, :price_type, :batch_size)
  end

  def item_prices_params
    params.permit(:item_id)

  end
end

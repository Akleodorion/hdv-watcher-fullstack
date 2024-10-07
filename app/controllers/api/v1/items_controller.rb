class Api::V1::ItemsController < ApplicationController

  def scrap
  # on recoit une liste d'item depuis la requête.
  # on itère sur la demande
  # vérification de l'éxistence de l'item en BDD
  # Si l'item existe.
  # Append
  # Sinon
  # Creation.
  end

  def paginated_items
    items_count = Item.all.count
    batch_size = paginated_items_params[:batch_index]
    number_of_baches = items_count.remainder(batch_size) == 0 ? (items_count / batch_size) : ( items_count / batch_size) + 1
    items =
    Item.where(ressource_type: RessourceTypes.types)
      .where("#{paginated_items_params[:price_type]}_info-->'is_worth' = 'true'")
      .order("CAST(#{paginated_items_params[:price_type]}_info->>'capital_gain' AS FLOAT) DESC")
      .limit(50)
      .offset(paginated_items_params[:batch_index] * 50)
    
    formated_items = [] 
    items.each do |item|
      formated_items << {
      name: item[:name],
      img_url: item[:img_url],
      ressource_type: item[:ressource_type],
      current_price: item["#{paginated_items_params[:price_type]}_info"][:price_list].last[:price],
      median_price: item["#{paginated_items_params[:price_type]}_info"][:median_price],
      capital_gain: item["#{paginated_items_params[:price_type]}_info"][:capital_gain]
      }
    end
    
    response = {
      "items": formated_items,
      "batch_size": number_of_baches,
    }

    render json: response
  end


  def item_prices
  item = Item.find(id: item_prices_params[:item_id])
  render json: item
  end


  private

  def paginated_items_params
    params.permit(:batch_index, :price_type)
  end

  def item_prices_params
    params.permit(:item_id)
  end
end

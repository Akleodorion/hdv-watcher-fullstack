class Api::V1::ItemsController < ApplicationController
  before_action :set_batch_size, only: %i[seeds_items seeds_info]

   # ***********************API MOBILE *************************    
  def index
    is_worth_active_record = {
      "unit_price": "unit_price_info->>'is_worth' = 'true'",
      "tenth_price": "tenth_price_info->>'is_worth' = 'true'",
      "hundred_price": "hundred_price_info->>'is_worth' = 'true'"
    }

    order_active_record = {
      "unit_price": "CAST(unit_price_info->>'capital_gain' AS FLOAT) DESC",
      "tenth_price": "CAST(tenth_price_info->>'capital_gain' AS FLOAT) DESC",
      "hundred_price": "CAST(hundred_price_info->>'capital_gain' AS FLOAT) DESC"
    }

    priceType = paginated_items_params[:price_type].to_sym
    @batch_size = paginated_items_params[:batch_size].to_i
    @items  = Item.where(ressource_type: RessourceTypes.types)
    @items = @items.where(is_worth_active_record[priceType])
    @items_count = Item.where(ressource_type: RessourceTypes.types).where(is_worth_active_record[priceType]).count
    @items = @items.order(Arel.sql(order_active_record[priceType]))
      .order(Arel.sql(order_active_record[priceType]))
      .limit(@batch_size)
      .offset( paginated_items_params[:batch_index].to_i * @batch_size)
    
  end

  def show
  @item = Item.find(item_prices_params[:id])
  end
  
  # ***********************Scrap related *************************    
  
  def scrap_entry
    # on recoit une liste d'item depuis la requête.
    # on itère sur la demande
    # vérification de l'éxistence de l'item en BDD
    # Si l'item existe.
    # Append
    # Sinon
    # Creation.
  end

  def scrap_info
    #recoit les informations relative au scrapping.
  end

  def seeds_items
  batch_index = params[:batch_index].to_i

  @items = Item.all
  @items = @items.limit(@batch_size)
  @items = @items.offset(batch_index * @batch_size)

  render json: @items
  end

  def seeds_info
    batch_count = (Item.all.count.to_f / @batch_size).ceil

    render json: {
      batch_count:
    }
  end

  private

  def paginated_items_params
    params.permit(:batch_index, :price_type, :batch_size)
  end

  def item_prices_params
    params.permit(:id)

  end

  def set_batch_size 
    @batch_size = 3
  end


end

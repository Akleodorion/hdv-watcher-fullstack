class Api::V1::ItemsController < ApplicationController
  before_action :set_batch_size, only: %i[seeds_items seeds_info]

  def index
    @price_type = paginated_items_params[:price_type].to_sym
    @selected_batch_size = paginated_items_params[:batch_size].to_i
    batch_index = paginated_items_params[:batch_index].to_i
    @price_type_map = {
      unit_price: :unit,
      tenth_price: :tenth,
      hundred_price: :hundred,
    }
    @items_count = Item.joins(:price_histories)
                  .where(ressource_type: RessourceTypes.types)
                  .where(price_histories: { price_type: @price_type_map[@price_type], is_worth: true }).count
    @items = Item.joins(:price_histories)
             .where(ressource_type: RessourceTypes.types)
             .where(price_histories: { price_type: @price_type_map[@price_type], is_worth: true })
             .select('items.id, items.name, items.img_url, items.ressource_type, price_histories.capital_gain, price_histories.current_price, price_histories.median_price')
             .order('price_histories.capital_gain DESC')
             .limit(@selected_batch_size)
             .offset(batch_index * @selected_batch_size)
  end

  def show
    @item = Item.find(item_prices_params[:id])
  end

  private

  def paginated_items_params
    params.permit(:batch_index, :price_type, :batch_size)
  end

  def item_prices_params
    params.permit(:id)
  end

  def fetch_items_by_price_type(price_type)
    
    
    return 

    
  end

  def paginated_items(items, batch_size)
    items.limit(batch_size).offset(paginated_items_params[:batch_index].to_i * batch_size)
  end

  def set_batch_size 
    @batch_size = 500
  end


end

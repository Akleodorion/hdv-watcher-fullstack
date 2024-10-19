class Api::V1::ItemsController < ApplicationController
  include ItemsActiveRecords
  before_action :set_batch_size, only: %i[seeds_items seeds_info]

   # ***********************API MOBILE *************************    
  def index
    price_type = paginated_items_params[:price_type].to_sym
    @selected_batch_size = paginated_items_params[:batch_size].to_i

    @items = fetch_items_by_price_type(price_type)
    @items_count = @items.count
    @items = paginated_items(@items, @selected_batch_size)
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

  def fetch_items_by_price_type(price_type)
    items = Item.where(ressource_type: RessourceTypes.types)
    items = items.where(is_worth_by_type(price_type))
    items.order(order_capital_gain_by_type(price_type))
  end

  def paginated_items(items, batch_size)
    items.limit(batch_size).offset(paginated_items_params[:batch_index].to_i * batch_size)
  end

  def set_batch_size 
    @batch_size = 3
  end


end

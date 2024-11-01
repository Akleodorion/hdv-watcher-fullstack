class Api::V1::SeedsController < ApplicationController
  
  def items
    index = seeds_params[:index].to_i
    @items = Item.all.limit(5).offset(index * 5)
  end

  def infos
    @items_count = Item.count
  end


  def seeds_params
    params.permit(:index)
  end
end
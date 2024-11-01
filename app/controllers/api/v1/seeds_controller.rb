class Api::V1::SeedsController < ApplicationController
  
  def items
    #renvoie les items, dans une quantité déterminer.
    index = seeds_params[:index].to_i
    @items = Item.all.limit(5).offset(index * 5)
  end

  def infos
    # renvoie des informations pour préparer un seeding.
    # 1. Le nombre d'item.
  end


  def seeds_params
    params.permit(:index)
  end
end
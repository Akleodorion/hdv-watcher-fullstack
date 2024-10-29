class Item < ApplicationRecord
  has_many :price_histories
  has_many :prices, through: :price_histories

  validates :img_url, :ressource_type, presence: true
  validates :name, presence: true, uniqueness: true


end

class Item < ApplicationRecord
  has_many :price_histories
  has_many :prices, through: :price_histories

  validates :img_url, :ressource_type, presence: true
  validates :name, presence: true, uniqueness: true

  after_create :set_basic_price_history


  private

  def set_basic_price_history;end

end

class PriceHistory < ApplicationRecord
  belongs_to :item
  has_many :prices

  enum :price_type, { unit: 0, tenth: 1, hundred: 2 }

  validates :median_price, :capital_gain, :current_price, :is_worth, :price_type, presence: true
end

class PriceHistory < ApplicationRecord
  belongs_to :item
  has_many :prices

  enum :price_type, { unit: 0, tenth: 1, hundred: 2 }

  validates :median_price, :capital_gain, :current_price, :is_worth, :price_type, presence: true

  def update_price_history
    set_median_price
    set_current_price
    set_capital_gain
    set_is_worth  
  end

  private

  def set_median_price;end

  def set_current_price;end

  def set_capital_gain;end

  def set_is_worth
    self.is_worth = capital_gain > 0 && current_price != 0
  end
end

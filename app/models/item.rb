class Item < ApplicationRecord
  has_many :price_histories, dependent: :destroy
  has_many :prices, through: :price_histories

  validates :img_url, :ressource_type, presence: true
  validates :name, presence: true, uniqueness: true

  after_create :set_basic_price_history


  private

  def set_basic_price_history
    Rails.logger.info "Callback set_basic_price_history triggered"
    PriceHistory.create!(is_worth: false, median_price: 0, capital_gain: 0, current_price: 0, price_type: 0, item_id: self.id)
    PriceHistory.create!(is_worth: false, median_price: 0, capital_gain: 0, current_price: 0, price_type: 1, item_id: self.id)
    PriceHistory.create!(is_worth: false, median_price: 0, capital_gain: 0, current_price: 0, price_type: 2, item_id: self.id)
  end

end

class Price < ApplicationRecord
  belongs_to :price_history

  validates :value, presence: true
  validates :date, presence: true

  after_create :update_price_history



  private
  # trigger de calculus of a new median,capital gain et current price.
  def update_price_history
    Rails.logger.info "Callback update_price_history triggered"
    price_history.update_price_history
  end
end

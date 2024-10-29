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

  def set_median_price
    # Récupérer la liste des prix.
    values = prices.map { |price| price.value }
    # Ordonner les prix.
    values.sort!
    # Retirer les zero et les doublons.
    filtered = []
    values.each do |value|
      filtered << value if value != 0 && value != filtered.last
    end
    # Déduire la longueur du tableau
    middle = filtered.count / 2
    # en déduire la médiane si c'est paire ou impaire.
    self.median_price = filtered.count % 2 == 0 ? filtered[middle] : (filtered[middle] + filtered[middle + 1]) / 2
  end

  def set_current_price
    self.current_price = prices.last.value 
  end

  def set_capital_gain
    self.capital_gain = median_price - (current_price + (median_price * 0.01).ceil )
  end

  def set_is_worth
    self.is_worth = capital_gain > 0 && current_price != 0
  end
end

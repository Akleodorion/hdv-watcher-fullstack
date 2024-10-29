class Price < ApplicationRecord
  belongs_to :price_history

  validates :value, presence: true
  validates :date, presence: true
end

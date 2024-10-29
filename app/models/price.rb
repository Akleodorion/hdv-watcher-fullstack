class Price < ApplicationRecord
  belongs_to :PriceHistory

  validates :value, presence: true
  validates :date, presence: true
end

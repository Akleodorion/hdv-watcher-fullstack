module ItemsActiveRecords
  extend ActiveSupport::Concern

  # price_type is a sym.
  def is_worth_by_type(price_type)
    is_worth_active_record = {
      "unit_price": "unit_price_info->>'is_worth' = 'true'",
      "tenth_price": "tenth_price_info->>'is_worth' = 'true'",
      "hundred_price": "hundred_price_info->>'is_worth' = 'true'"
    }
    is_worth_active_record[price_type]
  end

  def order_capital_gain_by_type(price_type)
    order_active_record = {
      "unit_price": "CAST(unit_price_info->>'capital_gain' AS FLOAT) DESC",
      "tenth_price": "CAST(tenth_price_info->>'capital_gain' AS FLOAT) DESC",
      "hundred_price": "CAST(hundred_price_info->>'capital_gain' AS FLOAT) DESC"
    }
    order_active_record[price_type]
  end
end
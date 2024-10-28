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

  def select_median_price_by_type(price_type)
    median_price_map = {
      unit_price: "unit_price_info ->> 'median_price' as median_price",
      tenth_price: "tenth_price_info ->> 'median_price' as median_price",
      hundred_price: "hundred_price_info ->> 'median_price' as median_price",
    }
    median_price_map[price_type]
  end

  def select_capital_gain_by_type(price_type)
    capital_gain_map = {
      unit_price: "unit_price_info ->> 'capital_gain' as capital_gain",
      tenth_price: "tenth_price_info ->> 'capital_gain' as capital_gain",
      hundred_price: "hundred_price_info ->> 'capital_gain' as capital_gain",
    }
    capital_gain_map[price_type]
  end

  def select_current_price_by_type(price_type)
    current_price_map = {
      unit_price: "unit_price_info ->> 'current_price' as current_price",
      tenth_price: "tenth_price_info ->> 'current_price' as current_price",
      hundred_price: "hundred_price_info ->> 'current_price' as current_price",
    }
    current_price_map[price_type]
  end

  def order_capital_gain_by_type(price_type)
    order_active_record = {
      "unit_price": "CAST(unit_price_info->>'capital_gain' AS FLOAT) DESC",
      "tenth_price": "CAST(tenth_price_info->>'capital_gain' AS FLOAT) DESC",
      "hundred_price": "CAST(hundred_price_info->>'capital_gain' AS FLOAT) DESC"
    }
    Arel.sql(order_active_record[price_type])
  end
end
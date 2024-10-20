class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :name
      t.string :img_url
      t.json :unit_price_info, default: {
      price_list: [],
      median_price: 0,
      capital_gain: 0,
      current_price: 0,
      is_worth: false,
      }
      t.json :tenth_price_info, default: {
        price_list: [],
        median_price: 0,
        capital_gain: 0,
        current_price: 0,
        is_worth: false,
        }
      t.json :hundred_price_info, default: {
        price_list: [],
        median_price: 0,
        capital_gain: 0,
        current_price: 0,
        is_worth: false,
        }
      t.string :ressource_type

      t.timestamps
    end
  end
end

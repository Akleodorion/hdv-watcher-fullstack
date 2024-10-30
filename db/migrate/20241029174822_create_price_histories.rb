class CreatePriceHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :price_histories do |t|
      t.integer :median_price
      t.integer :capital_gain
      t.integer :current_price
      t.boolean :is_worth, null: false
      t.integer :price_type
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end

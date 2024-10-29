class CreatePriceHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :price_histories do |t|
      t.integer :median_price, null: 0
      t.integer :capital_gain, null: 0
      t.integer :current_price, null: 0
      t.boolean :is_worth, null: false
      t.integer :price_type, null: 0
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class CreatePrices < ActiveRecord::Migration[7.1]
  def change
    create_table :prices do |t|
      t.integer :value, null: 0
      t.datetime :date
      t.references :PriceHistory, null: false, foreign_key: true

      t.timestamps
    end
  end
end

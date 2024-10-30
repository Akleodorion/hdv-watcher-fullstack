# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_10_29_174848) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "img_url"
    t.string "ressource_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "price_histories", force: :cascade do |t|
    t.integer "median_price"
    t.integer "capital_gain"
    t.integer "current_price"
    t.boolean "is_worth", null: false
    t.integer "price_type"
    t.bigint "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_price_histories_on_item_id"
  end

  create_table "prices", force: :cascade do |t|
    t.integer "value"
    t.datetime "date"
    t.bigint "price_history_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["price_history_id"], name: "index_prices_on_price_history_id"
  end

  add_foreign_key "price_histories", "items"
  add_foreign_key "prices", "price_histories"
end

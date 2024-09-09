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

ActiveRecord::Schema[7.1].define(version: 2024_09_08_103430) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "monthly_avg_ratings", force: :cascade do |t|
    t.bigint "shop_id", null: false
    t.integer "total_ratings"
    t.integer "total_reviews"
    t.float "avg_ratings"
    t.date "start_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id", "start_date"], name: "index_monthly_avg_ratings_on_shop_id_and_start_date", unique: true
    t.index ["shop_id"], name: "index_monthly_avg_ratings_on_shop_id"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "shop_id"
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["shop_id"], name: "index_products_on_shop_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "product_id"
    t.string "body"
    t.float "rating"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "tags", array: true
    t.string "reviewer_name"
    t.index ["product_id"], name: "index_reviews_on_product_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "tags", array: true
  end

  add_foreign_key "monthly_avg_ratings", "shops"
end

# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130814083710) do

  create_table "orders", force: true do |t|
    t.integer  "quantity",   default: 1
    t.integer  "stock_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "buy_price"
    t.decimal  "sell_price"
  end

  add_index "orders", ["stock_id"], name: "index_orders_on_stock_id"
  add_index "orders", ["user_id"], name: "index_orders_on_user_id"

  create_table "stocks", force: true do |t|
    t.string   "counter_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "symbol"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_url"
    t.string   "uid"
    t.string   "auth_token"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.string   "provider"
  end

end

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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121130075237) do

  create_table "addresses", :force => true do |t|
    t.integer  "user_id"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "post_code"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "addresses", ["city"], :name => "index_addresses_on_city"
  add_index "addresses", ["country"], :name => "index_addresses_on_country"
  add_index "addresses", ["user_id"], :name => "index_addresses_on_user_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "slug"
  end

  add_index "categories", ["name"], :name => "index_categories_on_name", :unique => true
  add_index "categories", ["slug"], :name => "index_categories_on_slug", :unique => true

  create_table "categorizations", :force => true do |t|
    t.integer  "product_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "categorizations", ["product_id", "category_id"], :name => "index_categorizations_on_product_id_and_category_id", :unique => true

  create_table "product_descriptions", :force => true do |t|
    t.integer  "product_id"
    t.text     "text"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "product_descriptions", ["product_id"], :name => "index_product_descriptions_on_product_id", :unique => true

  create_table "product_images", :force => true do |t|
    t.integer  "product_id"
    t.string   "image"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "sort_order"
    t.boolean  "default",    :default => false
  end

  add_index "product_images", ["product_id", "default"], :name => "index_product_images_on_product_id_and_default"
  add_index "product_images", ["product_id", "sort_order"], :name => "index_product_images_on_product_id_and_sort_order", :unique => true
  add_index "product_images", ["product_id"], :name => "index_product_images_on_product_id"

  create_table "products", :force => true do |t|
    t.integer  "seller_id"
    t.string   "title"
    t.decimal  "price",                     :precision => 8, :scale => 2
    t.datetime "created_at",                                                                 :null => false
    t.datetime "updated_at",                                                                 :null => false
    t.string   "slug"
    t.boolean  "status",                                                  :default => true
    t.integer  "quantity",                                                :default => 0
    t.decimal  "discounted_price",          :precision => 8, :scale => 2
    t.integer  "discounted_percentage_off"
    t.date     "discount_start_date"
    t.date     "discount_end_date"
    t.integer  "discount_days_left"
    t.boolean  "for_sale",                                                :default => false
  end

  add_index "products", ["discount_end_date"], :name => "index_products_on_discount_end_date"
  add_index "products", ["discount_start_date"], :name => "index_products_on_discount_start_date"
  add_index "products", ["for_sale", "quantity"], :name => "index_products_on_for_sale_and_quantity"
  add_index "products", ["for_sale"], :name => "index_products_on_for_sale"
  add_index "products", ["quantity"], :name => "index_products_on_quantity"
  add_index "products", ["seller_id"], :name => "index_products_on_seller_id"
  add_index "products", ["slug"], :name => "index_products_on_slug", :unique => true
  add_index "products", ["status"], :name => "index_products_on_status"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
    t.boolean  "seller",                 :default => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "brand"
    t.string   "slug"
  end

  add_index "users", ["brand"], :name => "index_users_on_brand", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["seller"], :name => "index_users_on_seller"
  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true

end

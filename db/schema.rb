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

ActiveRecord::Schema.define(:version => 20100928050916) do

  create_table "admins", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "customers", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "invitation_token",     :limit => 20
    t.datetime "invitation_sent_at"
    t.string   "name"
    t.text     "address"
    t.string   "postcode"
    t.string   "telephone"
    t.integer  "round_id",                                            :null => false
    t.integer  "supplier_id",                                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers", ["email"], :name => "index_customers_on_email", :unique => true
  add_index "customers", ["invitation_token"], :name => "index_customers_on_invitation_token"
  add_index "customers", ["reset_password_token"], :name => "index_customers_on_reset_password_token", :unique => true
  add_index "customers", ["round_id"], :name => "index_customers_on_round_id"
  add_index "customers", ["supplier_id"], :name => "index_customers_on_supplier_id"

  create_table "deliveries", :force => true do |t|
    t.date     "date"
    t.integer  "round_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_order"
  end

  create_table "order_items", :force => true do |t|
    t.integer  "order_id",   :null => false
    t.integer  "product_id", :null => false
    t.integer  "quantity",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "order_items", ["order_id", "product_id"], :name => "index_order_items_on_order_id_and_product_id", :unique => true

  create_table "orders", :force => true do |t|
    t.integer  "delivery_id",                       :null => false
    t.integer  "customer_id",                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "pending_update", :default => false, :null => false
  end

  add_index "orders", ["delivery_id", "customer_id"], :name => "index_orders_on_delivery_id_and_customer_id", :unique => true

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "price",             :precision => 7, :scale => 2
    t.string   "category"
    t.integer  "supplier_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sequence",                                        :default => 0, :null => false
    t.integer  "category_sequence",                               :default => 0, :null => false
  end

  create_table "regular_order_items", :force => true do |t|
    t.integer  "regular_order_id", :null => false
    t.integer  "product_id",       :null => false
    t.integer  "quantity",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "regular_order_items", ["regular_order_id", "product_id"], :name => "index_regular_order_items_on_regular_order_id_and_product_id", :unique => true

  create_table "regular_orders", :force => true do |t|
    t.integer  "customer_id",                              :null => false
    t.integer  "occurs_every_x_orders", :default => 1,     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "pending_update",        :default => false, :null => false
  end

  create_table "rounds", :force => true do |t|
    t.string   "name"
    t.string   "area"
    t.string   "schedule"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "supplier_id", :null => false
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "supplier_users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "invitation_token",     :limit => 20
    t.datetime "invitation_sent_at"
    t.integer  "supplier_id",                                         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "supplier_users", ["email"], :name => "index_supplier_users_on_email", :unique => true
  add_index "supplier_users", ["invitation_token"], :name => "index_supplier_users_on_invitation_token"
  add_index "supplier_users", ["reset_password_token"], :name => "index_supplier_users_on_reset_password_token", :unique => true

  create_table "suppliers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.text     "info"
  end

end

class CreateArchivedOrders < ActiveRecord::Migration
  def self.up
    create_table "archived_orders", :force => true do |t|
      t.integer  "delivery_id",                       :null => false
      t.integer  "customer_id",                       :null => false
      t.datetime "originally_created_at"
      t.datetime "originally_updated_at"
      t.text     "note"
    end

    add_index "archived_orders", ["delivery_id", "customer_id"], :name => "index_archived_orders_on_delivery_id_and_customer_id", :unique => true

    create_table :archived_order_items, :force => true  do |t|
      t.references :archived_orders
      t.integer  "product_id", :null => false
      t.integer  "quantity",   :null => false
      t.string   "product_name", :null => false
      t.decimal  "price",      :precision => 7, :scale => 2
    end

    add_index :archived_order_items, :archived_orders_id, :name => "index_archived_order_items_on_archived_order_id"

    add_column :deliveries, :archived, :boolean, :null => false, :default => 0
  end

  def self.down
    drop_table :archived_orders
    drop_table :archived_order_items
    remove_column :deliveries, :archived
  end
end

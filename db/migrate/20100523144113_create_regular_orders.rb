class CreateRegularOrders < ActiveRecord::Migration
  def self.up
    create_table :regular_orders do |t|
      t.references :customer, :null => false
      t.integer :occurs_every_x_orders, :null => false, :default => 1
      #start from the first delivery, so ensure that the first delivery they enter is a monday, probably need a tutorial on this!

      t.timestamps
    end

    create_table :regular_order_items do |t|
      t.references :regular_order, :null => false
      t.references :product, :null => false
      t.integer :quantity, :null => false

      t.timestamps
    end
    add_index :regular_order_items, [:regular_order_id, :product_id], :unique => true
  end

  def self.down
    drop_table :regular_orders
    drop_table :order
  end
end

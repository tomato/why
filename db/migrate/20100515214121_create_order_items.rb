class CreateOrderItems < ActiveRecord::Migration
  def self.up
    create_table :order_items do |t|
      t.references :order, :null => false
      t.references :product, :null => false
      t.integer :quantity, :null => false

      t.timestamps
    end
    add_index :order_items, [:order_id, :product_id], :unique => true
  end

  def self.down
    drop_table :order_items
  end
end

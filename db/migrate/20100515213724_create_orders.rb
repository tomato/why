class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.references :delivery, :null => false
      t.references :customer, :null => false

      t.timestamps
    end

    add_index :orders, [:delivery_id, :customer_id], :unique => true
  end

  def self.down
    drop_table :orders
  end
end

class AddFrequencyToReqularOrderItem < ActiveRecord::Migration
  def self.up
    add_column :regular_order_items, :frequency, :integer, :default => 1
    add_column :regular_order_items, :first_delivery_date, :date, :default => DateTime.now
    remove_column :regular_orders, :occurs_every_x_orders 
  end

  def self.down
    remove_column :regular_order_items, :frequency
    remove_column :regular_order_items, :first_delivery_date
    add_column :regular_orders,  :occurs_every_x_orders, :integer, :default => 1,     :null => false
  end
end

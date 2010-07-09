class AddOrderUpdatedColumns < ActiveRecord::Migration
  def self.up
    add_column :orders, :pending_update, :boolean, :null => false, :default => 0
    add_column :regular_orders, :pending_update, :boolean, :null => false, :default => 0
  end

  def self.down
    remove_column :orders, :pending_update
    remove_column :regular_orders, :pending_update
  end
end

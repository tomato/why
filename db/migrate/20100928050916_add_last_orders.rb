class AddLastOrders < ActiveRecord::Migration
  def self.up
    add_column :deliveries, :last_order , :datetime
  end

  def self.down
    remove_column :deliveries, :last_order
  end
end

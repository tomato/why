class AddNotesToOrdersAndRegular < ActiveRecord::Migration
  def self.up
    add_column :orders, :note, :text
    add_column :regular_orders, :note, :text
  end

  def self.down
    remove_column :orders, :note
    remove_column :regular_orders, :note
  end
end

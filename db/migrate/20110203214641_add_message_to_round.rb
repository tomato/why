class AddMessageToRound < ActiveRecord::Migration
  def self.up
    add_column :rounds, :customer_message, :text
  end

  def self.down
    remove_column :rounds, :customer_message
  end
end

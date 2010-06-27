class AddSequenceToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :sequence, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :products, :sequence
  end
end

class AddCategorySequenceToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :category_sequence, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :products, :category_sequence
  end
end

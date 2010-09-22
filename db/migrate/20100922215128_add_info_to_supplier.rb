class AddInfoToSupplier < ActiveRecord::Migration
  def self.up
    add_column :suppliers, :info,    :text
  end

  def self.down
    remove_column :suppliers, :info
  end
end

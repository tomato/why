class AddEmbedAndParentUrl < ActiveRecord::Migration
  def self.up
    add_column :suppliers, :embed, :bool, :null => false, :default => false
    add_column :suppliers, :parent_url, :string
  end

  def self.down
    remove_column :suppliers, :embed
    remove_column :suppliers, :parent_url
  end
end

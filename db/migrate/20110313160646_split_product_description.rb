class SplitProductDescription < ActiveRecord::Migration
  def self.up
    #add_column :products, :descriptive_text, :text
    #add_column :products, :photo_file_name, :string
    #add_column :products, :photo_content_type, :string
    #add_column :products, :photo_file_size, :integer
    #add_column :products, :photo_updated_at, :datetime
    Product.all.each do |p|
      p.split_description
      p.save
    end
  end

  def self.down
    remove_column :products, :descriptive_text
    remove_column :products, :photo_file_name
    remove_column :products, :photo_content_type
    remove_column :products, :photo_file_size
    remove_column :products, :photo_updated_at
  end
end

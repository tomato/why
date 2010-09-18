class AddLogoToSupplier < ActiveRecord::Migration
  def self.up
    add_column :suppliers, :logo_file_name,    :string
    add_column :suppliers, :logo_content_type, :string
    add_column :suppliers, :logo_file_size,    :integer
    add_column :suppliers, :logo_updated_at,   :datetime
  end

  def self.down
    remove_column :suppliers, :logo_file_name
    remove_column :suppliers, :logo_content_type
    remove_column :suppliers, :logo_file_size
    remove_column :suppliers, :logo_updated_at
  end

end

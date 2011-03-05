class AddEmailFooterToSupplier < ActiveRecord::Migration
  def self.up
    add_column :suppliers, :email_footer, :text
  end

  def self.down
    remove_column :suppliers, :email_footer
  end
end

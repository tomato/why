class AddFromSenderAndInviteTextToSupplier < ActiveRecord::Migration
  def self.up
    change_table :suppliers do |t|
      t.string :from_email
      t.text :invite
    end
  end

  def self.down
    remove_column :suppliers, :from_email
    remove_column :suppliers, :invite
  end
end

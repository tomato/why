class AddInvitationAcceptedAtToCustomersAndSupplierUsers < ActiveRecord::Migration
  def self.up
    change_table :customers do |t|
      t.datetime :invitation_accepted_at
    end

    change_column :customers, :encrypted_password, :string, :null => true
    change_column :customers, :password_salt,      :string, :null => true

    Customer.where("sign_in_count > 0").each do |u| 
      u.invitation_accepted_at = DateTime.new(2010,1,1)
      u.save
    end
    
    change_table :supplier_users do |t|
      t.datetime :invitation_accepted_at
    end

    change_column :supplier_users, :encrypted_password, :string, :null => true
    change_column :supplier_users, :password_salt,      :string, :null => true

    SupplierUser.where("sign_in_count > 0").each do |u| 
      u.invitation_accepted_at = DateTime.new(2010,1,1)
      u.save
    end
    
  end

  def self.down
    remove_column :customers, :invitation_accepted_at
    remove_column :supplier_users, :invitation_accepted_at
  end
end

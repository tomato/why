class DeviseCreateSupplierUsers < ActiveRecord::Migration
  def self.up
    create_table(:supplier_users) do |t|
      t.database_authenticatable :null => false
      #t.confirmable
      t.recoverable
      t.rememberable
      t.trackable
      # t.lockable
      t.invitable

      t.integer :supplier_id, :null => false
      t.timestamps
    end

    add_index :supplier_users, :email,                :unique => true
    #add_index :supplier_users, :confirmation_token,   :unique => true
    add_index :supplier_users, :reset_password_token, :unique => true
    # add_index :supplier_users, :unlock_token,         :unique => true
    add_index :supplier_users, :invitation_token # for invitable
  end

  def self.down
    drop_table :supplier_users
  end
end

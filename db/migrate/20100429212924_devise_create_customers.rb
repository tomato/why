class DeviseCreateCustomers < ActiveRecord::Migration
  def self.up
    create_table(:customers) do |t|
      t.database_authenticatable :null => false
      #t.confirmable
      t.recoverable
      t.rememberable
      t.trackable
      # t.lockable
      t.invitable
      t.string :name
      t.text :address
      t.string :postcode
      t.string :telephone

      t.integer :round_id, :null => false
      t.integer :supplier_id, :null => false
      t.timestamps
    end

    add_index :customers, :email,                :unique => true
    #add_index :customers, :confirmation_token,   :unique => true
    add_index :customers, :reset_password_token, :unique => true
    # add_index :customers, :unlock_token,         :unique => true
    add_index :customers, :invitation_token # for invitable
    add_index :customers, :round_id 
    add_index :customers, :supplier_id 
  end

  def self.down
    drop_table :customers
  end
end

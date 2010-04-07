class CreateSuppliers < ActiveRecord::Migration
  def self.up
    create_table :suppliers do |t|
      t.string :name

      t.timestamps
    end

    add_column :rounds, :supplier_id, :integer, :null => false
  end

  def self.down
    drop_table :suppliers
    remove_column :rounds, :supplier_id 
  end
end

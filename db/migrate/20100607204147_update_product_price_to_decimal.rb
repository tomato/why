class UpdateProductPriceToDecimal < ActiveRecord::Migration
  def self.up
    change_column :products, :price, :decimal, :precision => 7, :scale => 2
  end

  def self.down
    change_column :products, :price, :integer
  end
end

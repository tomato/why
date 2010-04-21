require 'spec_helper'

describe Product do
  describe "Validations" do
    before(:each) do
      @valid_attributes = {:name => 'test product', :price => '1.26' }
      @product = Product.new(@valid_attributes)
    end

    it "should create a new instance given valid attributes" do
      Product.create!(@valid_attributes)
    end

    it "should not be valid without a name" do
      @product.name = nil
      @product.should_not be_valid
    end

    it "should be valid with no price" do
      @product.price = nil
      @product.should be_valid
    end

    it "should not be valid with a no numberic price" do
      @product.price = 'hello'
      @product.should_not be_valid
    end

  end

  describe "Associations" do
    it "should belong to a supplier" do
      Product.new.supplier.should be_nil
    end
  end
end

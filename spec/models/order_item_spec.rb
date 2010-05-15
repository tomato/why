require 'spec_helper'

describe OrderItem do
  before(:each) do
    @valid_attributes = {
      :quantity => 1
      
    }
  end

  it "should create a new instance given valid attributes" do
    OrderItem.create!(@valid_attributes)
  end

  describe "associations" do
    it "should have a order" do
      OrderItem.new.order.should be_nil
    end

    it "should have a product" do 
      OrderItem.new.product.should be_nil
    end
  end

  describe "validations" do
    it "should not be valid without a quantity" do
      OrderItem.new.should_not be_valid
    end

  end
end

require 'spec_helper'

describe OrderItem do
  before(:each) do
    @valid_attributes = {
      :quantity => 1,
      :order_id => 1,
      :product_id => 1
      
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

    it "should not be valid without an order" do
      i = OrderItem.new(@valid_attributes)
      i.order_id = nil
      i.should_not be_valid
    end

    it "should not be valid without a product" do
      i = OrderItem.new(@valid_attributes)
      i.product_id = nil
      i.should_not be_valid
    end

    it "should not be valid if order and product already exists" do
      lambda{
      OrderItem.create(@valid_attributes)
      OrderItem.new(@valid_attributes).save
      }.should raise_error(ActiveRecord::StatementInvalid)
    end

  end
end

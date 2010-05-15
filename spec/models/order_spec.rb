require 'spec_helper'

describe Order do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Order.create!(@valid_attributes)
  end

  describe "associations" do
    it "should have a customer" do
      Order.new.customer.should == nil
    end

    it "should have a delivery" do 
      Order.new.delivery.should == nil
    end

    it "should have many order items" do 
      Order.new.order_items.should be_a Array
    end
  end

  describe "candidates" do
    it "should include an order for the next 12 deliveries" do
      @customer = Customer.new({:round_id => 1})
      Delivery.should_receive(:all).with(:conditions => 
        ["round_id = ? and date >= curdate()", 1], :limit => 12
      ).and_return(
        (1..12).to_a.map{ Delivery.new}
      )
      Order.find_candidates(@customer).should have(12).orders
    end
    
  end
end

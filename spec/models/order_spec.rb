require 'spec_helper'

describe Order do
  before(:each) do
    @valid_attributes = {
      :delivery_id => 1,
      :customer_id => 1 
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

  describe 'validations' do
    it 'should not be valid without a customer_id' do
      o = Order.new(@valid_attributes)
      o.customer_id = nil
      o.save.should be_false
    end

    it 'should not be valid without a delivery_id' do
      o = Order.new(@valid_attributes)
      o.delivery_id = nil
      o.save.should be_false
    end

    it "should only allow one order with the same delivery and customer" do 
      Order.create!(@valid_attributes).should be_true
      Order.new(@valid_attributes).save.should be_false
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

  describe "create_all" do
    before(:each) do
      @params = {"action"=>"create", "orders"=>{"0"=>{"items"=>{"0"=>{"quantity"=>"1", "product_id"=>"1"}, "1"=>{"quantity"=>"1", "product_id"=>"4"}}, "delivery_id"=>"654"}}, "controller"=>"orders", "customer_id"=>"2"}
    end

    it "should create an order" do
      Order.create_all(@params)
      Order.first.delivery_id.should == 654
      Order.first.customer_id.should == 2
    end

    it "should update an order if it already exists - since it is just primary keys nothing to update, create just returns" do
      Order.create_all(@params).should have(1).order
      Order.create_all(@params).should have(1).order
      Order.all.should have(1).order
    end
    
    it "should add items for an order" do 
      orders = Order.create_all(@params)
      orders.should have(1).order
      orders[0].should have(2).order_items
      orders[0].reload
      orders[0].should have(2).order_items
    end
  end
end

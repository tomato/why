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
      lambda{
      Order.create!(@valid_attributes).should be_true
      Order.new(@valid_attributes).save
      }.should raise_error(ActiveRecord::StatementInvalid)
    end
  end


  describe "find_candidates" do
    it "should include a new order for the next 12 deliveries if no orders exist" do
      @customer = Customer.new({:round_id => 1})
      Delivery.create_all(1, DateTime.now, DateTime.now.next_year,[0])
      Order.find_candidates(@customer).should have(12).orders
    end

    it "should find existing orders" do
      @customer = Factory(:customer)
      @delivery = Delivery.create!({:round_id => 1, :date => Date.new(2040,1,1)})
      @order = Order.create!({ :delivery_id => @delivery.id, :customer_id => @customer.id })
      Order.find_candidates(@customer)[0].should == @order
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

    it "should not allow adding of the same item twice" do
      @params_2_items = {"action"=>"create", "orders"=>{"0"=>{"items"=>{"0"=>{"quantity"=>"1", "product_id"=>"1"}, "1"=>{"quantity"=>"1", "product_id"=>"1"}}, "delivery_id"=>"654"}}, "controller"=>"orders", "customer_id"=>"2"}
      lambda{
      orders = Order.create_all(@params_2_items)
      }.should raise_error(ActiveRecord::StatementInvalid)
    end

    it "should not error if there are no orders to update" do
      @params = {"regular_orders"=>{"0"=>{"items"=>{"0"=>{"quantity"=>"1", "product_id"=>"4"}, "1"=>{"quantity"=>"1", "product_id"=>"5"}}, "regular_order_id"=>"undefined"}}, "action"=>"create", "controller"=>"orders", "customer_id"=>"2"}
      Order.create_all(@params).should have(0).orders
    end

    it "should create an order with no items" do
      @params = {"action"=>"create", "orders"=>{"0"=>{"delivery_id"=>"809"}}, "controller"=>"orders", "customer_id"=>"3"}
      Order.create_all(@params).should have(1).orders
    end

  end
end

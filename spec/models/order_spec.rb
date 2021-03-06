require 'spec_helper'

describe Order do
  before(:each) do
    @valid_attributes = {
      :delivery_id => 1,
      :customer_id => 1 
    }
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
    it "should include a new order for the next 6 deliveries if no orders exist" do
      @customer = Customer.new({:round_id => 1})
      Delivery.create_all(1, DateTime.now, DateTime.now.next_year,[0], LastOrdersDuration.new(0,0))
      Order.find_candidates(@customer).should have(6).orders
    end

    it "should find existing orders" do
      @customer = Factory(:customer)
      @delivery = Delivery.create!({:round_id => 1, :date => Date.new(2040,1,1), :last_order => Date.new(2040,1,1)})
      @order = Order.create!({ :delivery_id => @delivery.id, :customer_id => @customer.id })
      Order.find_candidates(@customer)[0].should == @order
    end
    
    it "should not find orders that have an expired last order" do
      @customer = Factory(:customer)
      @delivery = Delivery.create!({:round_id => 1, :date => Date.new(2040,1,1), :last_order => DateTime.now - 1.second})
      @order = Order.create!({ :delivery_id => @delivery.id, :customer_id => @customer.id })
      Order.find_candidates(@customer).should have(0).orders
    end
  end

  describe "pending updates" do
    it "should not return non pending orders" do
      Factory(:customer_with_orders)
      Order.find_pending_updates(1).should have(0).orders
    end

    it "should return pending orders" do
      c = Factory(:customer_with_orders)
      Order.first.update_attributes(:pending_update => 1)
      Order.find_pending_updates(c.supplier_id).should have(1).orders
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

    it "should set pending_update when an order is created by a customer" do
      orders = Order.create_all(@params, true)
      orders.first.pending_update.should be_true
    end

 #    it "should not set pending_update when an order is created by a supplier" do
 #      orders = Order.create_all(@params, false)
 #      orders.first.pending_update.should be_false
 #    end

    it "should set the pending_update when an order is updated by a customer" do
      orders = Order.create_all(@params, true)
      orders.first.update_attributes(:pending_update => false)
      orders.first.pending_update.should be_false
      orders = Order.create_all(@params, true)
      orders.first.pending_update.should be_true
    end
  end

  describe "items" do
    it "should return order_items" do
      o = Order.new
      o.order_items << OrderItem.new
      o.items.should have(1).item
    end

    it "should set order_items" do
      o = Order.new
      o.items << OrderItem.new
      o.order_items.should have(1).item
    end
  end

  describe "new_for_delivery" do
    it "should return a copy of a regular order" do
      r = Factory(:round)
      Delivery.create_all(r.id, DateTime.now, DateTime.now + 365.days, [0],LastOrdersDuration.new(0,0)).should be_>(1)
      c = Factory(:customer)
      r = Factory(:regular_order, :customer_id => c.id)
      o = Order.new_for_delivery(c, Delivery.first)
      o.should_not be_nil
      o.customer.should == c
      o.should have(1).item

    end

    it "should only contain items that a valid for that delivery" do
      r = Factory(:round)
      Delivery.create_all(r.id, DateTime.now, DateTime.now + 365.days, [0],LastOrdersDuration.new(0,0)).should be_>(1)
      c = Factory(:customer)
      r = Factory(:regular_order, :customer_id => c.id)
      r.items << Factory(:biweekly_regular_order_item)
      Order.new_for_delivery(c, Delivery.first).should have(2).item
      Order.new_for_delivery(c, Delivery.all[1]).should have(1).item
      Order.new_for_delivery(c, Delivery.all[2]).should have(2).item
    end

    it "should only include items after the start date" do
      r = Factory(:round)
      Delivery.create_all(r.id, DateTime.now, DateTime.now + 365.days, [0],LastOrdersDuration.new(0,0)).should be_>(1)
      c = Factory(:customer)
      r = Factory(:regular_order, :customer_id => c.id)
      r.items << Factory(:biweekly_regular_order_item, :first_delivery_date => DateTime.now + 7.days)
      Order.new_for_delivery(c, Delivery.first).should have(1).item
      Order.new_for_delivery(c, Delivery.all[1]).should have(2).item
      Order.new_for_delivery(c, Delivery.all[2]).should have(1).item
    end
  end

  describe :export_fields do
    it "should contain the quantity" do
      o = Factory(:order)
      o.export_fields.should eql(["order note", 1, 'asparagus', "1.32"])
      o.export_fields.should be_a(Array)
    end
  end

  describe :archive do

    before(:each) do
      @o = Factory(:order) 
      @o.archive
    end
    
    it "should create an ArchivedOrder" do
      ArchivedOrder.all.should have(1).order
      a = ArchivedOrder.first
      a.delivery_id.should == @o.delivery_id
      a.customer_id.should == @o.customer_id
      a.originally_created_at.to_s.should == @o.created_at.to_s
      a.originally_updated_at.to_s.should == @o.updated_at.to_s
      a.note.should == @o.note
    end

    it "should create archived order items" do
      ArchivedOrder.first.should have(1).archived_order_items
      oi = @o.items[0]
      i = ArchivedOrder.first.archived_order_items.first
      i.product_id.should == oi.product_id
      i.quantity.should == oi.quantity
      i.product_name.should == oi.product.name
      i.price.should == oi.product.price
    end
  end
end

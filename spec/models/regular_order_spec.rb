require 'spec_helper'

describe RegularOrder do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    customer = Factory(:customer)
    RegularOrder.create!(:customer_id => customer.id)
  end

  describe "find_or_new" do
    it "should return an existing if it exists" do
      customer = Factory(:customer)
      ro = RegularOrder.create!(:customer_id => customer.id)
      RegularOrder.find_or_new(customer).should have(1).regular_order
    end

    it "should return a new RegularOrder when none exist" do
      customer = Factory(:customer)
      RegularOrder.find_or_new(customer).should have(1).regular_order
    end
  end

  describe "create all" do
    before(:each) do
      @params = {"regular_orders"=>{"0"=>{"items"=>{"0"=>{"quantity"=>"1", "product_id"=>"4"}, "1"=>{"quantity"=>"1", "product_id"=>"5"}}, "regular_order_id"=>"undefined"}}, "action"=>"create", "orders"=>{"0"=>{"items"=>{"0"=>{"quantity"=>"1", "product_id"=>"2"}, "1"=>{"quantity"=>"2", "product_id"=>"4"}}, "delivery_id"=>"651"}}, "controller"=>"orders", "customer_id"=>"2"}
    end

    it "should create a regular order" do
      RegularOrder.create_all(@params)
      ro = RegularOrder.first
      ro.customer_id.should == 2
      ro.should have(2).regular_order_items
      roi = ro.regular_order_items.first
      roi.quantity.should == 1
      roi.product_id.should == 4
    end

    it "should throw an exception if it trys to create a second regular order" do
      RegularOrder.create_all(@params)
      lambda{
        RegularOrder.create_all(@params)
      }.should raise_error
    end

    it "should update a regular order" do
      ro = RegularOrder.create(:customer_id => '2')
      ro.should have(0).regular_order_items
      @params['regular_orders']["0"]['regular_order_id'] = ro.id
      RegularOrder.create_all(@params)
      ro.reload
      ro.should have(2).regular_order_items
      roi = ro.regular_order_items.first
      roi.quantity.should == 1
      roi.product_id.should == 4
    end

    it "should not error if there are no regular orders to update" do
      @params = {"orders"=>{"0"=>{"items"=>{"0"=>{"quantity"=>"1", "product_id"=>"2"}, "1"=>{"quantity"=>"2", "product_id"=>"4"}}, "delivery_id"=>"651"}}, "controller"=>"orders", "customer_id"=>"2"}
      RegularOrder.create_all(@params).should have(0).regular_orders
    end

    it "should not error if the regular order has not items" do
      @params = {"regular_orders"=>{"0"=>{"regular_order_id"=>"undefined"}}, "action"=>"create", "controller"=>"orders", "customer_id"=>"3"}
      RegularOrder.create_all(@params).should have(1).regular_orders
    end

    it "should set frequency to 1 and first delivery date to today if not defined" do
      @params = {"regular_orders"=>{"0"=>{"items"=>{"0"=>{"first_delivery_date"=>"undefined","frequency"=>"undefined","quantity"=>"1", "product_id"=>"4"}}, "regular_order_id"=>"undefined"}}, "action"=>"create", "orders"=>{"0"=>{"items"=>{"0"=>{"quantity"=>"1", "product_id"=>"2"}, "1"=>{"quantity"=>"2", "product_id"=>"4"}}, "delivery_id"=>"651"}}, "controller"=>"orders", "customer_id"=>"2"}
      RegularOrder.create_all(@params)
      ro = RegularOrder.first
      ro.items[0].frequency.should == 1
      ro.items[0].first_delivery_date.should_not be_nil
      
    end

    it "should set pending_update when an order is created by a customer" do
      orders = RegularOrder.create_all(@params, true)
      orders.first.pending_update.should be_true
    end

 #    it "should not set pending_update when an order is created by a supplier" do
 #      orders = RegularOrder.create_all(@params, false)
 #      orders.first.pending_update.should be_false
 #    end

    it "should set the pending_update when an order is updated by a customer" do
      orders = RegularOrder.create_all(@params, true)
      orders.first.update_attributes(:pending_update => false)
      orders.first.pending_update.should be_false
      @params['regular_orders']["0"]['regular_order_id'] = orders.first.id
      orders = RegularOrder.create_all(@params, true)
      orders.first.pending_update.should be_true
    end
  end
  
  describe "pending updates" do
    it "should not return non pending orders" do
      Factory(:customer_with_orders)
      RegularOrder.find_pending_updates(1).should have(0).orders
    end

    it "should return pending orders" do
      c = Factory(:customer_with_orders)
      RegularOrder.first.update_attributes(:pending_update => 1)
      RegularOrder.find_pending_updates(c.supplier_id).should have(1).regular_orders
    end
  end

  describe :to_csv do
    it "should return csv for an order" do
      csv = Factory(:order_with_real_customer).to_csv
      csv.should == "test,tom,42 East End Road,gl53 8qe,01242 523607,order note,1,asparagus,1.32\n"
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

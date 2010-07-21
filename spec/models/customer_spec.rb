require 'spec_helper'

describe Customer do

  describe "status" do
    before(:each) do
      @customer = Factory(:customer)
    end

    it "should return  :new for a new customer" do
      @customer.password = Customer::DEFAULT_PASSWORD
      @customer.status.should == :new
    end

    it "should return :invited for an invited customer" do
      @customer.invite!
      @customer.status.should == :invited
    end

    it "should return :active for a confirmed user" do
      @customer.invite!
      @customer.accept_invitation!
      @customer.status.should == :active
    end
  end

  describe "for_supplier" do
    it "should return a supplier of the specified id" do
      c = Factory(:customer)
      Customer.for_supplier(c.supplier_id).should have(1).customer
    end
    
    it "should not return a supplier from a different id" do
      c1 = Factory(:customer)
      c2 = Factory(:customer, :email => 't2@t.com')
      c1.supplier_id.should_not == c2.supplier_id
      Customer.for_supplier(c1.supplier_id).should have(1).customer
    end
  end

  describe "search" do
    it "should return a customer containing a name" do
      c = Factory(:customer, :name => "tommy tuckbox")
      Customer.with_query('tommy').should have(1).customer
    end

    it "should work with paginate" do
      c = Factory(:customer, :name => "tommy tuckbox")
      Customer.with_query('tommy').paginate(:page => 1).should have(1).customer
    end
  end

  describe "destroy" do
    it "should destroy orders and orderitems" do
      @customer = Factory(:customer_with_orders)
      customer_id = @customer.id
      order_id = @customer.orders.first.id
      Order.find_all_by_customer_id(customer_id).should have(1).order
      OrderItem.find_all_by_order_id(order_id).should have(1).order_item
      @customer.destroy
      Order.find_all_by_customer_id(customer_id).should have(0).order
      OrderItem.find_all_by_order_id(order_id).should have(0).order_item
    end

    it "should destroy regular_orders and orderitems" do
      @customer = Factory(:customer_with_orders)
      customer_id = @customer.id
      regular_order_id = @customer.regular_orders.first.id
      RegularOrder.find_all_by_customer_id(customer_id).should have(1).regular_order
      RegularOrderItem.find_all_by_regular_order_id(regular_order_id).should have(1).regular_order_item
      @customer.destroy
      RegularOrder.find_all_by_customer_id(customer_id).should have(0).regular_order
      RegularOrderItem.find_all_by_regular_order_id(regular_order_id).should have(0).regular_order_item
    end
  end

  describe "accept_changes" do
    it "should clear all pending order updates" do
      c = Factory(:customer_with_orders)
      o = c.orders.first
      o.update_attributes(:pending_update => 1)
      o.pending_update.should be_true
      Customer.accept_updates([c.id])
      o.reload
      o.pending_update.should be_false
    end
    
    it "should clear all pending order updates" do
      c = Factory(:customer_with_orders)
      o = c.regular_orders.first
      o.update_attributes(:pending_update => 1)
      o.pending_update.should be_true
      Customer.accept_updates([c.id])
      o.reload
      o.pending_update.should be_false
    end
  end
end

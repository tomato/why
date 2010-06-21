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
end

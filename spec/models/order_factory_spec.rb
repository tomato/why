require 'spec_helper'

describe OrderFactory do
  
  before(:each) do
    supplier_id = Factory(:supplier).id
    @customer = customer_with_pending_orders supplier_id
  end

  describe "find_all_pending" do
    it "should return orders and regular orders" do
      OrderFactory.find_all_pending(@customer.supplier_id).should have(2).orders
    end
  end

  describe "pending_customers" do 
    it "should return a customer with 2 orders" do
      grouped_orders = OrderFactory.pending_customers(@customer.supplier_id)
      c = grouped_orders.first
      c[0].should == @customer
      c[1].should have(2).orders
    end

#     it "should be ordered by the date of the change (oldest first)" do
#       supplier_id = Factory(:supplier).id
#       c1 = customer_with_pending_orders supplier_id
#       c2 = customer_with_pending_orders supplier_id
#       c3 = customer_with_pending_orders supplier_id
#       c2.orders.first.update_attributes(:updated_at => DateTime.new + 10)
#       grouped_orders = OrderFactory.pending_customers(supplier_id).to_a
#       grouped_orders[0][0].should == c1.id
#       puts grouped_orders[0][1][0].updated_at
#       puts grouped_orders[1][1][0].updated_at
#       puts grouped_orders[2][1][0].updated_at
#       grouped_orders[1][0].should == c3.id
#       grouped_orders[2][0].should == c2.id
#     end

  end

  private

  def customer_with_pending_orders(supplier_id)
    c = Factory(:customer_with_orders, :supplier_id => supplier_id)
    c.orders.first.update_attributes(:pending_update => 1)
    c.regular_orders.first.update_attributes(:pending_update => 1)
    return c
  end
end

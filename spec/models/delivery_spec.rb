require 'spec_helper'

describe Delivery do
  before(:each) do
    @valid_attributes = [
      
    ]
  end

  it "should create a new instance given valid attributes" do
    Delivery.create!(@valid_attributes)
  end
  describe "create_all" do
    it "should create delieries on specified days if delivery days are saturday (17th) and monday (19th)" do
      Delivery.create_all(1, Date.new(2210,4,16), Date.new(2210, 4, 23), [6,1])
      Delivery.all.should have(3).deliveries
    end


    it "should create deliveries on the from and to date if it falls on a delivery day" do
      Delivery.create_all(1, Date.new(2210,4,16), Date.new(2210, 4, 16), [5,1])
      Delivery.all.should have(1).deliveries
      delivery = Delivery.find_by_date(Date.new(2210,4,16))
      delivery.should be_a(Delivery)
      delivery.round_id.should eql(1)
    end

    it "should create no deliveries in to date is before from date" do
      Delivery.create_all(1, Date.new(2210,4,16), Date.new(2210, 4, 15), [5,1])
      Delivery.all.should have(0).deliveries
    end

    it "should not create a delivery for the same date on the same round twice" do
      Delivery.create_all(1, Date.new(2210,4,16), Date.new(2210, 4, 16), [5,1])
      Delivery.all.should have(1).deliveries
      Delivery.create_all(1, Date.new(2210,4,16), Date.new(2210, 4, 16), [5,1])
      Delivery.all.should have(1).deliveries
    end

    it "should create no dates if no days are selected" do
      Delivery.create_all(1, Date.new(2000,4,16), Date.new(2210, 4, 16), [])
      Delivery.all.should have(0).delvieries
    end

  end
  
  describe "Days" do
    it "should return a hash of days with their id in the correct orders" do
      Delivery.days.should == [[1 , "Monday"], [2 , "Tuesday"], [3 , "Wednesday"], [4 , "Thursday"], [5 , "Friday"], [6 , "Saturday"], [0 , "Sunday"]]
      Delivery.days[0].should == [ 1, "Monday"]
    end
  end

  describe "next_10" do
    before(:each) do
      @supplier = Factory(:supplier)
      @r1 = Factory(:round, :supplier => @supplier)
      Delivery.create_all(@r1.id, Date.new(2210,4,16), Date.new(2210, 5, 16), [1]).should == 5
      @r2 = Factory(:round, :supplier => @supplier)
      Delivery.create_all(@r2.id, Date.new(2210,4,16), Date.new(2210, 5, 30), [4,5,6,1,2,3]).should == 39
    end

    it "should return the next ten delivery dates for this supplier" do
      Delivery.next_10_dates(@supplier.id).should have(10).dates
    end

    it "should return them with the next first" do
      Delivery.next_10_dates(@supplier.id).first[0].should == Date.new(2210, 4, 16)
    end

    describe "if there are multiple rounds on a delviery day" do
      it "should only show the delivery date once" do
        Delivery.next_10_dates(@supplier.id).find_all{ |d| d[0] == Date.new(2210,4,16)}.should have(1).delivery
      end

      it "should contain the round_ids for the date" do
        (Delivery.next_10_dates(@supplier.id).find_all{ |d| d[0] == Date.new(2210,4,16)}
          ).first[1].should have(2).ids
      end
    end
  end

  describe :all_orders_for do
    before(:each) do
      @round = Factory(:round)
      @delivery = Factory(:delivery, {:round_id => @round.id })
      @customer = Factory(:customer, {:round_id => @round.id })
      @customer2 = Factory(:customer, {:round_id => @round.id })
    end

    it "should return a regular order if no order exists" do
      @regular_order = Factory(:regular_order, {:customer_id => @customer.id})
      orders = @delivery.all_orders
      orders.should have(1).regular_order
      orders.first.should be_a(RegularOrder)
    end

    it "should return an order if it exists" do
      @regular_order = Factory(:regular_order, {:customer_id => @customer.id})
      @order = Factory(:order, {:customer_id => @customer.id, :delivery_id => @delivery.id })
      orders = @delivery.all_orders
      orders.should have(1).regular
      orders.first.should be_a(Order)
    end

    it "should return nothing for the customer if no regular or normal order exist" do
      @delivery.all_orders.should have(0).orders
    end

    it "should return an order for each customer on the round" do
      @order = Factory(:order, {:customer_id => @customer.id, :delivery_id => @delivery.id })
      @order2 = Factory(:order, {:customer_id => @customer2.id, :delivery_id => @delivery.id })
      orders = @delivery.all_orders
      orders.should have(2).orders
      orders.find{|o| o.customer_id == @customer.id}.id.should == @order.id
      orders.find{|o| o.customer_id == @customer2.id}.id.should == @order2.id
    end

    it "should return nothing for orders with no items but other orders should still be included" do
      @order = Factory(:order, {:customer_id => @customer.id, :delivery_id => @delivery.id })
      @order2 = Factory(:order, {:customer_id => @customer2.id, :delivery_id => @delivery.id })
      @order2.items.clear
      @order2.save!
      @order2.items.should be_empty
      @delivery.all_orders.should have(1).orders
    end

    describe :all_orders_csv do
      it "should return a single string" do
        Factory(:order, {:delivery_id => @delivery.id, :customer_id => @customer.id})
        Factory(:order, {:delivery_id => @delivery.id, :customer_id => @customer2.id})
        @delivery.all_orders_csv.should == "tom,42 East End Road,gl53 8qe,01242 523607,1,asparagus,1.32\ntom,42 East End Road,gl53 8qe,01242 523607,1,asparagus,1.32\n"
      end
    end

    describe :all_produce do
      it "should include the sum of the produce for each order" do 
        @order = Factory(:order, {:delivery_id => @delivery.id, :customer_id => @customer.id})
        product = @order.items[0].product
        @round.supplier.products.clear
        @round.supplier.products << product
        p = @delivery.all_produce
        p[0].should == [product.id,1]
      end
    end
  end
end

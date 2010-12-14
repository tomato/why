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
      Delivery.create_all(1, Date.new(2210,4,16), Date.new(2210, 4, 23), [6,1], LastOrdersDuration.new(0,0))
      Delivery.all.should have(3).deliveries
    end


    it "should create deliveries on the from and to date if it falls on a delivery day" do
      Delivery.create_all(1, Date.new(2210,4,16), Date.new(2210, 4, 16), [5,1], LastOrdersDuration.new(0,0))
      Delivery.all.should have(1).deliveries
      delivery = Delivery.find_by_date(Date.new(2210,4,16))
      delivery.should be_a(Delivery)
      delivery.round_id.should eql(1)
    end

    it "should create no deliveries in to date is before from date" do
      Delivery.create_all(1, Date.new(2210,4,16), Date.new(2210, 4, 15), [5,1], LastOrdersDuration.new(0,0))
      Delivery.all.should have(0).deliveries
    end

    it "should not create a delivery for the same date on the same round twice" do
      Delivery.create_all(1, Date.new(2210,4,16), Date.new(2210, 4, 16), [5,1], LastOrdersDuration.new(0,0))
      Delivery.all.should have(1).deliveries
      Delivery.create_all(1, Date.new(2210,4,16), Date.new(2210, 4, 16), [5,1], LastOrdersDuration.new(0,0))
      Delivery.all.should have(1).deliveries
    end

    it "should create no dates if no days are selected" do
      Delivery.create_all(1, Date.new(2000,4,16), Date.new(2210, 4, 16), [], LastOrdersDuration.new(0,0))
      Delivery.all.should have(0).delvieries
    end

    it "should create last_order date the same as delivery date if last_order_duration is 0" do
      Delivery.create_all(1, Date.new(2210,4,16), Date.new(2210, 4, 16), [5,1], LastOrdersDuration.new(0,0))
      ds = Delivery.all
      ds.should have(1).deliveries
      ds.first.last_order.should === ds.first.date
    end

    it "should create last_order date different to delivery date if last_order_duration is 1 day 1 hour" do
      Delivery.create_all(1, Date.new(2210,4,16), Date.new(2210, 4, 16), [5,1], LastOrdersDuration.new(1,1))
      ds = Delivery.all
      ds.should have(1).deliveries
      ds.first.last_order.should === ds.first.date - 82800.seconds
    end
  end
  
  describe "Days" do
    it "should return a hash of days with their id in the correct orders" do
      Delivery.days.should == [[1 , "Monday"], [2 , "Tuesday"], [3 , "Wednesday"], [4 , "Thursday"], [5 , "Friday"], [6 , "Saturday"], [0 , "Sunday"]]
      Delivery.days[0].should == [ 1, "Monday"]
    end
  end

  describe "next_dates" do
    before(:each) do
      @supplier = Factory(:supplier)
      @r1 = Factory(:round, :supplier => @supplier)
      Delivery.create_all(@r1.id, Date.new(2210,4,16), Date.new(2210, 5, 16), [1], LastOrdersDuration.new(0,0)).should == 5
      @r2 = Factory(:round, :supplier => @supplier)
      Delivery.create_all(@r2.id, Date.new(2210,4,16), Date.new(2210, 5, 30), [4,5,6,1,2,3], LastOrdersDuration.new(0,0)).should == 39
    end

    it "should return the next ten delivery dates for this supplier" do
      Delivery.next_dates(@supplier.id, 10).should have(10).dates
    end

    it "should return them with the next first" do
      Delivery.next_dates(@supplier.id, 10).first.should == Date.new(2210, 4, 16)
    end

    describe "if there are multiple rounds on a delviery day" do
      it "should only show the delivery date once" do
        Delivery.next_dates(@supplier.id, 10).find_all{ |d| d == Date.new(2210,4,16)}.should have(1).delivery
      end
    end
  end

  describe :all_orders_for do
    before(:each) do
      @round = Factory(:round)
      @delivery = Factory(:delivery, {:round_id => @round.id, :date => DateTime.new(2010,1,1) })
      @customer = Factory(:customer, {:round_id => @round.id })
      @customer2 = Factory(:customer, {:round_id => @round.id })
    end

    it "should return a regular order if no order exists" do
      @regular_order = Factory(:regular_order, {:customer_id => @customer.id})
      RegularOrder.first.items.any?{|i| i.is_required_for_delivery @delivery}.should be_true
      orders = @delivery.all_orders
      orders.should have(1).order
      orders.first.should be_a(Order)
    end

    it "should return a regular order with valid items" do
      @regular_order = Factory(:regular_order, {:customer_id => @customer.id})
      @regular_order.items << Factory(:regular_order_item, :first_delivery_date => DateTime.new(2011,1,1))
      @regular_order.should have(2).items
      RegularOrder.first.items.select{|i| i.is_required_for_delivery @delivery}.should have(1).item
      RegularOrder.first.items.select{|i| !i.is_required_for_delivery @delivery}.should have(1).item
      orders = @delivery.all_orders
      orders.should have(1).order
      orders.first.should have(1).item
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
        @delivery.all_orders_csv.should == " 1 Jan,tom,42 East End Road,gl53 8qe,01242 523607,,1,asparagus,1.32\n 1 Jan,tom,42 East End Road,gl53 8qe,01242 523607,,1,asparagus,1.32\n"
      end

      it "should return an empty string if no id's are passed" do
        @delivery.all_orders_csv.should == ""
      end
    end

    describe :all_produce do
      it "should include the price of the produce for an order" do 
        @order = Factory(:order, {:delivery_id => @delivery.id, :customer_id => @customer.id})
        product = @order.items[0].product
        @round.supplier.products.clear
        @round.supplier.products << product
        p = @delivery.all_produce
        p[0][0].should == product.id
        p[0][3].should == 1
      end

    end

    describe :for_supplier do
      it "should return a supplier by friendly_id" do
        d = Factory(:delivery)
        Delivery.for_supplier(d.round.supplier).first.should_not be_nil
      end
    end

    describe "ids_for_dates" do 
      before(:each) do
        date = Date.new(2010,1,1)
        @supplier = Factory(:supplier)
        @round = Factory(:round, :supplier => @supplier)
        @delivery1 = Factory(:delivery, {:round_id => @round.id, :date => date })
        @delivery2 = Factory(:delivery, {:round_id => @round.id, :date => date + 1.day})
        @delivery3 = Factory(:delivery, {:round_id => @round.id, :date => date + 2.day})
      end

      it "should return one date if present" do
        ids = Delivery.ids_for_dates(@supplier, @delivery1.date, nil, nil)
        ids.should_not be_nil
        ids.should have(1).items
      end

      it "should return range of dates start and end date are present" do
        ids = Delivery.ids_for_dates(@supplier, nil, @delivery1.date, @delivery3.date)
        ids.should_not be_nil
        ids.should have(3).items
      end

      it "should return no ids if only a start date is present" do
        ids = Delivery.ids_for_dates(@supplier, nil, @delivery1.date, nil)
        ids.should_not be_nil
        ids.should have(0).items
      end

      it "should return no ids if only a end date is present" do
        ids = Delivery.ids_for_dates(@supplier, nil, nil, @delivery1.date)
        ids.should_not be_nil
        ids.should have(0).items
      end

      it "should return no ids if only a end date is before start date" do
        ids = Delivery.ids_for_dates(@supplier, nil, @delivery2.date, @delivery1.date)
        ids.should_not be_nil
        ids.should have(0).items
      end
    end
  end
end

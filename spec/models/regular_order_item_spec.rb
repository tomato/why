require 'spec_helper'

describe RegularOrderItem do
  before(:each) do
    @valid_attributes = {
      :product_id => 1,
      :regular_order_id => 1,
      :quantity => 1
    }
  end

  it "should create a new instance given valid attributes" do
    RegularOrderItem.create!(@valid_attributes)
  end

  describe :is_required_for_delivery do
    before(:each) do
      r = Factory(:round)
      Delivery.create_all(r.id, DateTime.now, DateTime.now + 365.days, [0],LastOrdersDuration.new(0,0)).should be_>(1)
      @deliveries = Delivery.where :round_id => r.id
      @deliveries.should_not be_empty
    end
    it "should be true if the frequency is 1" do 
      i = RegularOrderItem.new  :frequency => 1, :first_delivery_date => @deliveries[1].date
      i.is_required_for_delivery(@deliveries[3]).should be_true
    end

    it "should be true for the first_delivery_date" do
      i = RegularOrderItem.new  :frequency => 8, :first_delivery_date => @deliveries[3].date
      i.is_required_for_delivery(@deliveries[3]).should be_true
    end

    it "should not be true for the delivery after the first_delivery_date if frequency is 2" do
      i = RegularOrderItem.new  :frequency => 2, :first_delivery_date => @deliveries[1].date
      i.is_required_for_delivery(@deliveries[2]).should be_false
    end

    it "should be true for the delivery  4 after the first_delivery_date if frequency is 2" do
      i = RegularOrderItem.new  :frequency => 2, :first_delivery_date => @deliveries[1].date
      i.is_required_for_delivery(@deliveries[5]).should be_true
    end

    it "should be true for the delivery  16 after the first_delivery_date if frequency is 8" do
      i = RegularOrderItem.new  :frequency => 8, :first_delivery_date => @deliveries[1].date
      i.is_required_for_delivery(@deliveries[17]).should be_true
    end

    it "should be false for the delivery  17 after the first_delivery_date if frequency is 8" do
      i = RegularOrderItem.new  :frequency => 8, :first_delivery_date => @deliveries[1].date
      i.is_required_for_delivery(@deliveries[18]).should be_false
    end

    it "should be able to add deliveris in any order (use date not id!!!!!)" do
      r = Factory(:round)
      Delivery.create_all(r.id, DateTime.now, DateTime.now + 60.days, [0],LastOrdersDuration.new(0,0)).should be_>(1)
      Delivery.create_all(r.id, DateTime.now - 60.days, DateTime.now, [0],LastOrdersDuration.new(0,0)).should be_>(1)
      @deliveries = Delivery.where :round_id => r.id
      i = RegularOrderItem.new  :frequency => 2, :first_delivery_date => @deliveries[1].date
      i.is_required_for_delivery(@deliveries[5]).should be_true
    end
  end
end

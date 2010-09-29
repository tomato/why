require 'spec_helper'

describe LastOrdersDuration do

  it "should set seconds_till_last_orders to be 0" do
    LastOrdersDuration.new(0,0).to_i.should == 0
  end

  it "should set seconds_till_last_orders to be -86400 for 1 day" do
    LastOrdersDuration.new(1,0).to_i.should == 86400
  end

  it "should set seconds_till_last_orders to be -82800 for 1 day 1hour" do
    LastOrdersDuration.new(1,1).to_i.should == 82800
  end

  it "should set seconds_till_last_orders to be 82800 for 3 day 4hour" do
    LastOrdersDuration.new(3,4).to_i.should == 244800
  end

  it "should return a last order duration with 0 days zero hours when seconds_till_last_orders is 0" do
    l = LastOrdersDuration.from_seconds(0)
    l.days.should == 0
    l.hour_of_day.should == 0
  end

  it "should return a last order duration with 1 days zero hours when seconds_till_last_orders is -86400" do
    l = LastOrdersDuration.from_seconds(86400)
    l.days.should == 1
    l.hour_of_day.should == 0
  end

  it "should return a last order duration with 1 days 1 hours when seconds_till_last_orders is -82800" do
    l = LastOrdersDuration.from_seconds(82800)
    l.days.should == 1
    l.hour_of_day.should == 1
  end

  it "should return a last order duration with 3 days 4 hours when seconds_till_last_orders is 244800" do
    l = LastOrdersDuration.from_seconds(244800)
    l.days.should == 3
    l.hour_of_day.should == 4
  end

end

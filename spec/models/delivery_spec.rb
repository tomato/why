require 'spec_helper'

describe Delivery do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Delivery.create!(@valid_attributes)
  end

  it "should create delieries on specified days if delivery days are saturday (17th) and monday (19th)" do
    Delivery.create_all(1, Date.new(2010,4,16), Date.new(2010, 4, 23), [6,1])
    Delivery.all.should have(2).deliveries
    Delivery.find_by_date(Date.new(2010,4,17)).should be_a(Delivery)
    Delivery.find_by_date(Date.new(2010,4,19)).should be_a(Delivery)
  end


  it "should create deliveries on the from and to date if it falls on a delivery day" do
    Delivery.create_all(1, Date.new(2010,4,16), Date.new(2010, 4, 16), [5,1])
    Delivery.all.should have(1).deliveries
    delivery = Delivery.find_by_date(Date.new(2010,4,16))
    delivery.should be_a(Delivery)
    delivery.round_id.should eql(1)
  end

  it "should create no deliveries in to date is before from date" do
    Delivery.create_all(1, Date.new(2010,4,16), Date.new(2010, 4, 15), [5,1])
    Delivery.all.should have(0).deliveries
  end

  it "should not create a delivery for the same date on the same round twice" do
    Delivery.create_all(1, Date.new(2010,4,16), Date.new(2010, 4, 16), [5,1])
    Delivery.all.should have(1).deliveries
    Delivery.create_all(1, Date.new(2010,4,16), Date.new(2010, 4, 16), [5,1])
    Delivery.all.should have(1).deliveries
  end

  it "should create no dates if no days are selected" do
    Delivery.create_all(1, Date.new(2000,4,16), Date.new(2010, 4, 16), [])
    Delivery.all.should have(0).delvieries
  end

  it "should return the number of deliveries create" do
    Delivery.create_all(1, Date.new(2010,4,16), Date.new(2010, 4, 16), [5]).should == 1
    Delivery.create_all(1, Date.new(2010,4,16), Date.new(2010, 4, 16), [5]).should == 0
  end
    
    
  
end

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
  
  describe "Days" do
    it "should return a hash of days with their id in the correct orders" do
      Delivery.days.should == [[1 , "Monday"], [2 , "Tuesday"], [3 , "Wednesday"], [4 , "Thursday"], [5 , "Friday"], [6 , "Saturday"], [0 , "Sunday"]]
      Delivery.days[0].should == [ 1, "Monday"]
    end
  end

  describe "next_10" do
    before(:each) do
      @r1 = Factory(:round)
      Delivery.create_all(@r1.id, Date.new(2010,4,16), Date.new(2010, 5, 16), [5]).should == 5
      @r2 = Factory(:round)
      Delivery.create_all(@r2.id, Date.new(2010,4,16), Date.new(2010, 5, 30), [5,6,1,2,3]).should == 32
    end

    it "should return the next ten delivery dates for this supplier" do
      Delivery.next_10(1).should have(10).deliveries
    end

    it "should return them with the next first" do
      Delivery.next_10(1).first.date.should == Date.new(2010, 4, 16)
    end

    describe "if there are multiple rounds on a delviery day" do
      it "should only show the delivery date once" do
        Delivery.next_10(1).find_all{ |d| d.date == Date.new(2010,4,16)}.should have(1).delivery
      end
    end
  end
end

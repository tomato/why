require 'spec_helper'

describe RoundsController do

  #Delete this example and add some real ones
  it "should use RoundsController" do
    controller.should be_an_instance_of(RoundsController)
  end

  describe "show" do
    describe "delivery_months" do
      it "should return an array of months and years" do
        Round.stub!(:find).and_return(nil)
        deliveries = [Delivery.new(:date => Date.new(2010,4,2)),
          Delivery.new(:date => Date.new(2009,12,2)),
          Delivery.new(:date => Date.new(2008,12,2)),
          Delivery.new(:date => Date.new(2009,12,3))]
        Delivery.stub!(:find_all_by_round_id).and_return(deliveries)

        get :show
        dm = assigns[:delivery_months]

        assigns[:deliveries].count.should == 4
        dm.should be_a(Hash)
        dm[Date.new(2010,4,1)].should have(1).delivery
        dm[Date.new(2009,12,1)].should have(2).delivery
        dm[Date.new(2008,12,1)].should have(1).delivery
      end
    end
  end

end

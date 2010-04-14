require 'spec_helper'

describe DeliveriesController do

  #Delete this example and add some real ones
  it "should use DeliveriesController" do
    controller.should be_an_instance_of(DeliveriesController)
  end
  
  describe "Create" do
    it "should send message to delivery" do
      Delivery.should_receive(:create_all).with(7, Date.new(2010,4,14), Date.new(2011,4,14),["Monday", "Wednesday","Thursday"])
      post :create, { "to"=>{"month"=>"4", "day"=>"14", "year"=>"2011"}, "from"=>{"month"=>"4", "day"=>"14", "year"=>"2010"},  "day"=>["Monday", "Wednesday","Thursday"],"round"=>"7"}
    end
  end

end

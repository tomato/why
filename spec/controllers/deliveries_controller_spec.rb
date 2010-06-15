require 'spec_helper'

describe DeliveriesController do

  #Delete this example and add some real ones
  it "should use DeliveriesController" do
    controller.should be_an_instance_of(DeliveriesController)
  end

  it "should only be accessable to admin or correct supplier user" do
    get :show
    response.should redirect_to home_path
  end
  
  describe "logged in supplier user" do
    before(:each) do
      sign_in_admin
    end

    describe "Create" do
      it "should send message to delivery" do
        Delivery.should_receive(:create_all).with(7, Date.new(2010,4,14), Date.new(2011,4,14),[1,3,4])
        post :create, { "to"=>{"month"=>"4", "day"=>"14", "year"=>"2011"}, "from"=>{"month"=>"4", "day"=>"14", "year"=>"2010"},  "day"=>["1","3","4"],"round"=>"7"}
      end

      it "should return a warning if no days are selected" do
        Delivery.should_not_receive(:create_all)
        post :create, { "to"=>{"month"=>"4", "day"=>"14", "year"=>"2011"}, "from"=>{"month"=>"4", "day"=>"14", "year"=>"2010"},  "day"=>[],"round"=>"7"}
        flash[:notice].should == "You need to select the day(s) your round is on"
      end
        
      it "should return a warning if the to date is not on or after the from date" do 
        Delivery.should_not_receive(:create_all)
        post :create, { "to"=>{"month"=>"4", "day"=>"14", "year"=>"2010"}, "from"=>{"month"=>"4", "day"=>"14", "year"=>"2011"},  "day"=>["0"],"round"=>"7"}
        flash[:notice].should == "Your 'to' date needs to be after your 'from' date"
      end
      
      it "should return a warning if the to date is not valid" do 
        Delivery.should_not_receive(:create_all)
        post :create, { "to"=>{"month"=>"2", "day"=>"31", "year"=>"2010"}, "from"=>{"month"=>"4", "day"=>"14", "year"=>"2008"},  "day"=>["0"],"round"=>"7"}
        flash[:notice].should == "Your 'to' date is not a valid"
      end

      it "should return a warning if the from date is not valid" do 
        Delivery.should_not_receive(:create_all)
        post :create, { "to"=>{"month"=>"2", "day"=>"3", "year"=>"2010"}, "from"=>{"month"=>"2", "day"=>"31", "year"=>"2008"},  "day"=>["0"],"round"=>"7"}
        flash[:notice].should == "Your 'from' date is not a valid"
      end

      it "should return a notice if 1 new delivery was added" do
        Delivery.should_receive(:create_all).and_return(1)
        post :create, { "to"=>{"month"=>"4", "day"=>"14", "year"=>"2010"}, "from"=>{"month"=>"4", "day"=>"14", "year"=>"2010"},  "day"=>["3"],"round"=>"7"}
        flash[:notice].should == "1 new delivery was added"
      end

      it "should return a notice if 3 new delivery was added" do
        Delivery.should_receive(:create_all).and_return(3)
        post :create, { "to"=>{"month"=>"4", "day"=>"14", "year"=>"2010"}, "from"=>{"month"=>"4", "day"=>"14", "year"=>"2010"},  "day"=>["3"],"round"=>"7"}
        flash[:notice].should == "3 new deliveries were added"
      end

      it "should return a notice if no new delivery was added" do
        Delivery.should_receive(:create_all).and_return(0)
        post :create, { "to"=>{"month"=>"4", "day"=>"14", "year"=>"2010"}, "from"=>{"month"=>"4", "day"=>"14", "year"=>"2010"},  "day"=>["3"],"round"=>"7"}
        flash[:notice].should == "No new deliveries were added"
      end
    end
  end

end

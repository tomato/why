require 'spec_helper'

#mokey patch should be fix in next version of rspec-rails
module RSpec::Rails
  module ControllerExampleGroup

    def flunk(message)
      assert_block(message){false}
    end

  end
end


describe SuppliersController do

  #Delete this example and add some real ones
  it "should use SupplierController" do
    controller.should be_an_instance_of(SuppliersController)
  end

  it " should not allow a supplier to see index, new or create" do
    [:index, :new].each do |action|
      get action
      response.should redirect_to ADMIN_SIGN_IN_URL
    end

    put :create
    response.should redirect_to ADMIN_SIGN_IN_URL
  end

  it "should not allow suppliers to view other suppliers" do
    Supplier.stub!(:find).and_return(nil)
    @su = SupplierUser.new(:email => 'tom@tomhowett.com', :password => 'fishfry', :supplier_id => 1)
    @su.save.should be_true
    sign_in(@su).should be_true
    get :show, {:id => 3}
    response.should redirect_to home_path
  end

  it "should allow supplier user to view their own supplier" do
    @request.host = "t.example.com"
    s = Factory(:supplier, :name => 't')
    @su = SupplierUser.new(:email => 'tom@tomhowett.com', :password => 'fishfry', :supplier_id => s.id)

    s.friendly_id.should == 't'
    @su.save.should be_true
    sign_in(@su).should be_true
    get :show, {:id => 't'}
    response.should render_template("show")
  end

  describe :download do
    before(:each) do
      @request.host = "t.example.com"
      @supplier = Factory(:supplier, :name => 't')
      @su = SupplierUser.new(:email => 'tom@tomhowett.com', :password => 'fishfry', :supplier_id => @supplier.id)
      @su.save.should be_true
      sign_in(@su).should be_true
    end

    it "should call method with the deliveries specified if one_date is passed" do
      Delivery.should_receive(:all_orders_csv).and_return("")
      Delivery.should_receive(:ids_for_dates).with(@supplier, Date.new(2010,11,11), "", "").and_return(nil)
      post :download,  {"authenticity_token"=>"u8YvtfsAUSwqM79DIHhlo2VKDuHBkDqthFNItsKAY7Q=", "utf8"=>"\342\234\223", "from_date"=>"", "id"=>"toms-organics", "to_date"=>"", "one_date"=>"2010-11-11"}
    end
    

  end


end

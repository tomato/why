require 'spec_helper'

describe OrdersController do

  #Delete this example and add some real ones
  it "should use OrdersController" do
    controller.should be_an_instance_of(OrdersController)
  end

  describe "create" do
    before(:each) do
      @params = {"action"=>"create", "orders"=>{"0"=>{"items"=>{"0"=>{"name"=>"Dummy", "quantity"=>"1"}, "1"=>{"name"=>"Semi-skimmed pint", "quantity"=>"1"}}, "delivery_id"=>"654"}}, "controller"=>"orders", "customer_id"=>"2"}
    end

    it "should create a new order for each order updated" do
      Order.should_receive(:create_all).with(@params)
      post :create, @params
      response.body.should include('We updated your order')
    end

    it "should display an error if create fails" do
      Order.should_receive(:create_all).with(@params).and_raise(Exception)
      post :create, @params
      response.body.should include('This was an error:')
    end
  end

end

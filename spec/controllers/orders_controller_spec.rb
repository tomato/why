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
      RegularOrder.should_receive(:create_all).with(@params)
      Order.should_receive(:create_all).with(@params)
      post :create, @params
      response.body.should include('We updated your order')
    end

    it "should display an error if create fails" do
      RegularOrder.should_receive(:create_all).with(@params).and_raise(Exception)
      post :create, @params
      response.body.should include('This was an error:')
    end

    it "should not error if there are no orders to update" do
      @params = {"regular_orders"=>{"0"=>{"items"=>{"0"=>{"quantity"=>"1", "product_id"=>"4"}, "1"=>{"quantity"=>"1", "product_id"=>"5"}}, "regular_order_id"=>"undefined"}}, "action"=>"create", "controller"=>"orders", "customer_id"=>"2"}
      post :create, @params
      response.body.should include('We updated your order')
    end
  end

end

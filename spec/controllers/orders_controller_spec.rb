require 'spec_helper'

describe OrdersController do

  before(:each) do
    @customer = Factory(:customer)
  end

  #Delete this example and add some real ones
  it "should use OrdersController" do
    controller.should be_an_instance_of(OrdersController)
  end

  describe "index" do
    describe "Annonymous User" do
      it "should redirect to login page" do
        get :index, :customer_id => @customer.id
        response.should redirect_to home_path
      end
    end

    describe "Logged in as Admin" do
      it "should show the page" do
        sign_in_admin
        get :index, :customer_id => @customer.id
        response.should be_success
      end
    end


    describe "logged in as correct supplier" do 
      it "should be successful" do
        @su = Factory.build(:supplier_user)
        @su.supplier = @customer.supplier
        @su.save!
        sign_in @su
        get :index, :customer_id => @customer.id
        response.should be_success
      end

    end

    describe "logger in as wrong supplier" do
      it "should redirect to home" do
        @su = Factory.build(:supplier_user)
        @su.supplier_id = @customer.supplier_id + 1
        @su.save!
        sign_in @su
        get :index, :customer_id => @customer.id
        response.should redirect_to home_path
      end
    end

    describe "logged in as wrong Customer" do
      it "should redirect" do
        sign_in @customer
        get :index, :customer_id => @customer.id + 1
        response.should redirect_to home_path
      end
    end

    describe "logged in as correct Customer" do
      it "should be successful" do
        sign_in @customer
        get :index, :customer_id => @customer.id 
        response.should be_success
      end
    end

  end


  describe "create" do
    before(:each) do
      @params = {"action"=>"create", "orders"=>{"0"=>{"items"=>{"0"=>{"name"=>"Dummy", "quantity"=>"1"}, "1"=>{"name"=>"Semi-skimmed pint", "quantity"=>"1"}}, "delivery_id"=>"654"}}, "controller"=>"orders", "customer_id"=> @customer.id.to_s}
    end

    describe "Logged in as correct Customer" do
      before(:each) do
        sign_in @customer
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
    end

  end

end

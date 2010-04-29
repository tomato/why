require 'spec_helper'

describe SuppliersController do

  #Delete this example and add some real ones
  it "should use SupplierController" do
    controller.should be_an_instance_of(SuppliersController)
  end

  it " should not allow a supplier to see index, new or create" do
    [:get, :new].each do |action|
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
    get :show, {:id => 2}
    response.should redirect_to ADMIN_SIGN_IN_URL
  end


end

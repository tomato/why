require 'spec_helper'

describe SupplierUsersController do

  #Delete this example and add some real ones
  it "should use SupplierUsersController" do
    controller.should be_an_instance_of(SupplierUsersController)
  end

  it "should not allow annonymous to go to new" do
    get :new
    response.should redirect_to CUSTOMER_SIGN_IN_URL
  end
  
  it "should not allow annonymous to create a new supplier" do
    put :create
    response.should redirect_to CUSTOMER_SIGN_IN_URL
  end

end

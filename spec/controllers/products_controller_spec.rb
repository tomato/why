require 'spec_helper'

describe ProductsController do

  #Delete this example and add some real ones
  it "should use ProductsController" do
    controller.should be_an_instance_of(ProductsController)
  end

  it "should not allow an annoymous user" do 
    get :show
    response.should redirect_to SUPPLIER_USER_SIGN_IN_URL
  end

end

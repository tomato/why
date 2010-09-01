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
    Supplier.stub!(:find).and_return(nil)
    @su = SupplierUser.new(:email => 'tom@tomhowett.com', :password => 'fishfry', :supplier_id => 1)
    @su.save.should be_true
    sign_in(@su).should be_true
    get :show, {:id => 1}
    response.should render_template("show")
  end


end

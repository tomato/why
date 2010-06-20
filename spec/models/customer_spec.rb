require 'spec_helper'

describe Customer do

  before(:each) do
    @customer = Factory(:customer)
  end

  describe "status" do
    it "should return  :new for a new customer" do
      @customer.password = Customer::DEFAULT_PASSWORD
      @customer.status.should == :new
    end

    it "should return :invited for an invited customer" do
      @customer.invite!
      @customer.status.should == :invited
    end

    it "should return :active for a confirmed user" do
      @customer.invite!
      @customer.accept_invitation!
      @customer.status.should == :active
    end
  end
end

require 'spec_helper'

describe Delivery do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Delivery.create!(@valid_attributes)
  end
  
end

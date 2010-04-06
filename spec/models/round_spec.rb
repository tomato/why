require 'spec_helper'

describe Round do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Round.create!(@valid_attributes)
  end
  
  describe "Associations" do
    it "should have many deliveries" do
      r = Round.new
      r.deliverys << Delivery.new
      r.should have(1).deliverys

    end
  end
end

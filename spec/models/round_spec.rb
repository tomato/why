require 'spec_helper'

describe Round do
  before(:each) do
    @valid_attributes = {
      :supplier_id => 1
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
  
  describe "destroy" do
    it "should raise an error if the round has customers" do
      r = Factory(:round)
      r.customers << Factory(:customer)
      lambda{r.destroy}.should raise_error(ActiveRecord::RecordNotDestroyed)
    end

    it "remove any related deliveries" do
      r = Factory(:round)
      r.deliverys << Factory(:delivery, {:round_id => r.id})
      r.destroy
      Delivery.all.empty?
    end
  end
  
end

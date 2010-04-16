require 'spec_helper'

describe Supplier do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Supplier.create!(@valid_attributes)
  end

  describe "Associations" do
    it "can have many rounds" do 
      Supplier.new.should have(0).rounds
    end
      
  end
end

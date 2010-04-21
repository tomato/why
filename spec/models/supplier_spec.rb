require 'spec_helper'

describe Supplier do
  describe "validations" do
    before(:each) do
      @valid_attributes = {:name => 'test supplier' }
      @supplier = Supplier.new(@valid_attributes)
    end

    it "should create a new instance given valid attributes" do
      Supplier.create!(@valid_attributes)
    end

    it "should not be valid without a name" do
      @supplier.name = nil
      @supplier.should_not be_valid
    end
  end
    
  describe "Associations" do
    it "can have many rounds" do 
      Supplier.new.should have(0).rounds
    end

    it "can have many products" do
      Supplier.new.should have(0).products
    end
  end

end

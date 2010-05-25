require 'spec_helper'

describe RegularOrderItem do
  before(:each) do
    @valid_attributes = {
      :product_id => 1,
      :regular_order_id => 1,
      :quantity => 1
    }
  end

  it "should create a new instance given valid attributes" do
    RegularOrderItem.create!(@valid_attributes)
  end
end

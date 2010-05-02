require 'spec_helper'

describe SupplierUser do
  it "should not allow 2 users with the same email" do
    a = SupplierUser.new(:email => 't@a.com', :password => 'a12345', :supplier_id => 1)
    a.save.should be_true
    b = SupplierUser.new(:email => 't@a.com', :password => 'a12345', :supplier_id => 1)
    b.save.should be_false
  end

end

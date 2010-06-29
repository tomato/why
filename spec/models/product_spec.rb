require 'spec_helper'

describe Product do
  describe "Validations" do
    before(:each) do
      @valid_attributes = {:name => 'test product', :price => '1.26' }
      @product = Product.new(@valid_attributes)
    end

    it "should create a new instance given valid attributes" do
      Product.create!(@valid_attributes)
    end

    it "should not be valid without a name" do
      @product.name = nil
      @product.should_not be_valid
    end

    it "should be valid with no price" do
      @product.price = nil
      @product.should be_valid
    end

    it "should not be valid with a no numberic price" do
      @product.price = 'hello'
      @product.should_not be_valid
    end

  end

  describe "Associations" do
    it "should belong to a supplier" do
      Product.new.supplier.should be_nil
    end
  end

  describe "update_sequences" do
    it "should update sequences" do
      p1 = Factory(:product)
      p2 = Factory(:product)
      Product.update_sequences([p2.id, p1.id], 1)
      p2.reload.sequence.should == 1
      p1.reload.sequence.should == 2
    end

    it "should not error if nothing to upadate" do
      Product.update_sequences(nil, 1)
    end
  end

  describe "update_category_sequences" do
    it "should update sequences" do
      p1 = Factory(:product, :category => "a")
      p2 = Factory(:product, :category => "b")
      Product.update_category_sequences([p2.id, p1.id], 1)
      p2.reload.category_sequence.should == 1
      p1.reload.category_sequence.should == 2
    end

    it "should update all sequences for that category" do
      p1 = Factory(:product, :category => "a")
      p2 = Factory(:product, :category => "b")
      p3 = Factory(:product, :category => "b")
      Product.update_category_sequences([p2.id, p1.id], 1)
      p3.reload.category_sequence.should == 1
      p2.reload.category_sequence.should == 1
      p1.reload.category_sequence.should == 2
    end
  end

  describe "Sorting" do
    it "should sort by sequence" do
      products = [
        p1 = Factory(:product, :category => "a"),
        p2 = Factory(:product, :category => "b"),
        p3 = Factory(:product, :category => "b")
      ]
      Product.update_category_sequences([p2.id, p1.id], 1)
      Product.update_sequences([p3.id, p2.id], 1)
      products.each{ |p| p.reload }
      products.sort.first.id.should == p3.id
      products.sort.second.id.should == p2.id
      products.sort.last.id.should == p1.id
    end
  end
end

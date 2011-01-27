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

    it "should be valid with a category name" do
      @product.category = 'organic flours'
      @product.should be_valid
    end

    it "should not be valid with a comma in category name" do
      @product.category = 'organic flours, fish and meat'
      @product.should_not be_valid
    end

    it "should not be valid with a apostrophe in category name" do
      @product.category = "organic flour's fish and meat"
      @product.should_not be_valid
    end

    it "should not be valid with an ampersand in category name" do
      @product.category = "organic flours fish & meat"
      @product.should_not be_valid
    end

    it "should be valid with a space in category name" do
      @product.category = ""
      @product.should be_valid
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

  describe "set_category_sequence" do

    before(:each) do
      products = [
        @p1 = Factory(:product, :category => "a"),
        @p2 = Factory(:product, :category => "b"),
        @p3 = Factory(:product, :category => "b")
      ]
      Product.update_category_sequences([@p2.id,@p1.id], 1)
      Product.update_sequences([@p3.id, @p2.id], 1)
      products.each{ |p| p.reload }

      @p1.category_sequence.should == 2
      @p2.category_sequence.should == 1
      @p3.category_sequence.should == 1
    end

    it "should update the sequence id when sequence is changed to existing" do
      @p2.category = @p1.category
      @p2.save!
      @p2.category_sequence.should == @p1.category_sequence
    end

    it "should set a new category sequence to 0" do
      @p2.category = "c"
      @p2.save!
      @p2.category_sequence.should == 0
    end
  end

  describe "destroy" do
    it "should remove order items" do 
      o = Factory(:order)
      o.should have(1).order_items
      p = o.order_items.first.product
      p.destroy
      o.reload
      o.should have(0).order_items
    end

    it "should remove reqular order items" do
      o = Factory(:regular_order)
      o.should have(1).regular_order_items
      p = o.regular_order_items.first.product
      p.destroy
      o.reload
      o.should have(0).regular_order_items
    end
  end

end

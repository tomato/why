require "spec_helper"

describe Confirm do
  describe "to_customer" do
    before(:each) do
      @c = Factory(:customer_with_orders)
    end
    let(:mail) { Confirm.to_customer(@c)}

    it "renders the headers" do
      mail.subject.should eq("Your order confirmation")
      mail.to.should eq([@c.email])
      mail.from.should eq("to.@to.com")
    end

    it "renders the Customer Name" do
      mail.body.encoded.should match("tom")
    end

    it "renders a regular order product name" do
      mail.body.encoded.should match("asparagus")
    end

    it "renders a regular order note" do
      mail.body.encoded.should match("regular order note")
    end

    it "should not show changed order text if there arent any" do
      @c.orders.clear
      @c.should have(0).orders
      mail.body.encoded.should_not match("But on the following dates you will receive")
    end

    it "should show changed order text if there is one" do
      @c.should have(1).orders
      mail.body.encoded.should match("But on the following dates you will receive")
    end

    it "should show a footer if there is one" do
      @c.supplier.email_footer = "thanks for all the fish"
      mail.body.encoded.should match(@c.supplier.email_footer )
    end
  end

end

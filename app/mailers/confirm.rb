class Confirm < ActionMailer::Base

  def to_customer(customer) 
    @customer = customer
    mail :to => customer.email, 
      :from => customer.supplier.from_email,
      :subject => 'Your order confirmation'
  end
end

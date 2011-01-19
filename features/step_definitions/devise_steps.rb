Given /^I am not authenticated as a customer$/ do
  visit('/customers/sign_out') # ensure that at least
end

Given /^I am authenticated as a customer with a supplier named fred$/ do
  customer = Factory(:customer)
  Capybara.default_host = "fred.fwig.me"
  switch_session('fred')
  visit('/customers/sign_out')
  visit("/customers/sign_in")
  fill_in("Email", :with => customer.email)
  fill_in("Password", :with => customer.password)
  click_button("Sign In")
end

Given /^I have a customer with a supplier named fred$/ do
  Factory(:customer)
end

Then /^I should be redirected to (.+)$/ do |url|
  response.should redirect_to url 
end


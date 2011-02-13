Given /^I am not authenticated as a customer$/ do
  visit('/customers/sign_out') # ensure that at least
end

Given /^I am not authenticated as a supplier/ do
  visit('/supplier_users/sign_out') # ensure that at least
end

Given /^I am authenticated as a customer with a supplier named fred$/ do
  customer = Factory(:customer_with_round)
  Capybara.default_host = "fred.fwig.me"
  switch_session('fred')
  visit('/customers/sign_out')
  visit("/customers/sign_in")
  fill_in("Email", :with => customer.email)
  fill_in("Password", :with => customer.password)
  click_button("Sign In")
end

Given /^I am authenticated as a supplier with a supplier named fred$/ do
  customer = Factory(:supplier_user)
  Capybara.default_host = "fred.fwig.me"
  switch_session('fred')
  visit('/supplier_users/sign_out')
  visit("/supplier_users/sign_in")
  fill_in("Email", :with => customer.email)
  fill_in("Password", :with => customer.password)
  click_button("Sign In")
end



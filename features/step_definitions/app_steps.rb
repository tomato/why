

Given /^I have a supplier called (.+)/ do |name|
  Factory(:supplier, :name => name)
end

When /^I visit subdomain "([^"]*)"$/ do |subdomain|
  Capybara.default_host = "#{subdomain}.fwig.me"
  switch_session(subdomain)
  visit("http://#{subdomain}.fwig.me")
end

Given /^I have a customer with a supplier named fred$/ do
  Factory(:customer_with_round)
end

Given /^I have a supplier user with a supplier named fred$/ do
  Factory(:supplier_user)
end

Then /^log the html$/ do
  puts response.body.inspect
end

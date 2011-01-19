

Given /^I have a supplier called (.+)/ do |name|
  Factory(:supplier, :name => name)
end

Given /^I am in subdomain "(.+)"$/ do |subdomain|
  Capybara.default_host = "#{subdomain}.fwig.me"
  switch_session(subdomain)
  visit("http://#{subdomain}.fwig.me")
end


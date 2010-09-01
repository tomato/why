SUPPLIER_USER_SIGN_IN_URL = 'http://test.host/supplier_users/sign_in?unauthenticated=true'
ADMIN_SIGN_IN_URL = 'http://test.host/admins/sign_in'
CUSTOMER_SIGN_IN_URL = 'http://test.host/customers/sign_in?unauthenticated=true'

module SignIns
  def sign_in_admin
    @admin = Admin.new(:email => 'tom@tomhowett.com', :password => 'fishfry')
    @admin.save.should be_true
    sign_in(@admin).should be_true
  end
  
  def sign_in_supplier_user
    @su = SupplierUser.new(:email => 'tom@tomhowett.com', :password => 'fishfry', :supplier_id => 1)
    @su.save.should be_true
    sign_in(@su).should be_true
  end
end

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, comment the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  config.include(SignIns, :type => :controller)
end



Feature: Customer Sign In

  So that a customer can update their order
  When a customer signs in 
  They should be taken to their order page

  Scenario: Access suppliers home page without loging in
    Given I have a supplier called fred
    And I am not authenticated as a customer
    When I go to fred's home page
    Then I should see "Sign In"
    And I should see "Welcome to fred's Ordering System"
    
  Scenario: Access home page without loging in
    Given I am not authenticated as a customer
    When I go to the home page
    Then I should see "Home - We like our food to come - From Where It's Grown"

  Scenario: Sign In  should take you to suppliers home page
    Given I have a customer with a supplier named fred 
    And I am not authenticated as a customer
    When I visit subdomain "fred"
    And I fill in "Email" with "person1@example.com"
    And I fill in "Password" with "ab1234"
    And I press "Sign In"
    Then I should see "Help me!"
    And I should see "Regular Order"

  Scenario: Customer Try to log in with wrong password
    Given I have a customer with a supplier named fred 
    And I am not authenticated as a customer
    When I visit subdomain "fred"
    And I fill in "Email" with "person1@example.com"
    And I fill in "Password" with ""
    And I press "Sign In"
    Then I should see "Sign In"

  Scenario: Customer should not be able to access supplier pages
    Given I am authenticated as a customer with a supplier named fred
    When I visit subdomain "fred"
    And I go to fred's customer page
    Then I should see "Help me!"

  Scenario: Logged in customer goes directly to orders page
    Given I am authenticated as a customer with a supplier named fred
    And I am on another site
    When I visit subdomain "fred"
    Then I should see "Help me!"
    And I should see "Regular Order"

  Scenario: Supplier Sign in should take you to dashboard
    Given I have a supplier user with a supplier named fred
    And I am not authenticated as a supplier
    When I visit subdomain "fred"
    And I follow "I'm a supplier get me out of here!"
    And I fill in "Email" with "s@t.com"
    And I fill in "Password" with "ab1234"
    And I press "Sign In"
    Then I should see "Dashboard"
    And I should see "Customers"
    And I should see "Products"
    And I should see "Rounds"
    And I should see "Team"
    And I should see "Settings"
    And I should not see "Suppliers"

  Scenario: Logged in supplier goes directly to dashboard page
    Given I am authenticated as a supplier with a supplier named fred
    And I am on another site
    When I visit subdomain "fred"
    Then I should see "Dashboard"

  Scenario: Supplier should not be able to access other suppliers pages
    Given I am authenticated as a supplier with a supplier named fred
    And I have a supplier called Invalid
    When I visit subdomain "invalid"
    And I go to invalid's customer page
    Then I should see "Welcome to Invalid's Ordering System"

  Scenario: Invalid subdomain should return to home page
    When I visit subdomain "invalid"
    Then I should see "Invalid Subdomain"
    And I should see "Simple Order Management"

  Scenario: Password reset?



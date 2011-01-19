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
    And I am in subdomain "fred"
    When I fill in "Email" with "person1@example.com"
    And I fill in "Password" with "ab1234"
    And I press "Sign In"
    Then I should see "Flummoxed? Watch the video"
    And I should see "Regular Order"

  Scenario: Customer Try to log in with wrong password
    Given I have a customer with a supplier named fred 
    And I am not authenticated as a customer
    And I am in subdomain "fred"
    When I fill in "Email" with "person1@example.com"
    And I fill in "Password" with ""
    And I press "Sign In"
    Then I should see "Sign In"

  Scenario: Logged in customer goes directly to orders page
    Given I am authenticated as a customer with a supplier named fred
    And I am on another site
    And I am in subdomain "fred"
    Then I should see "Flummoxed? Watch the video"
    And I should see "Regular Order"


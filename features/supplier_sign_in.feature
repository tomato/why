Feature: Supplier Sign In

  When suppliers sign in they should to the dashbord
 
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



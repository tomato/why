Feature: Embed changes layout

  Scenario: login page does not show header for embeded sites
    Given I have a supplier called fred
    And fred has chosen to embed the site
    When I visit subdomain "fred"
    Then I should see "Sign In"
    And I should not see the header

  Scenario: login page does show header for non embeded sites
    Given I have a supplier called fred
    When I visit subdomain "fred"
    Then I should see "Sign In"
    And I should see the header

  Scenario: orders page does not show header for embedded site
    Given I am authenticated as a customer with a supplier named fred
    And fred has chosen to embed the site
    When I visit subdomain "fred"
    And I go to fred's customer page
    Then I should not see the header
    
  Scenario: orders page does show header for non embedded site
    Given I am authenticated as a customer with a supplier named fred
    When I visit subdomain "fred"
    And I go to fred's customer page
    Then I should see the header

  Scenario: all pages does show header for embedded site for supplier user
    Given I am authenticated as a supplier with a supplier named fred
    And fred has chosen to embed the site
    When I visit subdomain "fred"
    Then I should see "Dashboard"
    And I should see the header




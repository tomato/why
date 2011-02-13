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

  Scenario: Invite should redirect to parent after password set 
    Given I invite a new user for fred
    And fred has chosen to embed the site
    And I am not authenticated as a customer
    When I visit subdomain "fred"
    When I go to invite page
    And I fill in "Password" with "hollo22"
    And I fill in "Password confirmation" with "hollo22"
    And I press "Set my password"
    Then I should be on "parent page"
  
  Scenario: Should redirect to parent after pasword reset
    Given I have a customer who has forgotten their password
    And fred has chosen to embed the site
    When I go to reset password page
    And I fill in "Password" with "hollo22"
    And I fill in "Password confirmation" with "hollo22"
    And I press "Change my password"
    Then I should be on "parent page"



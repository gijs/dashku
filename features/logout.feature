Feature: logout
  In order to make sure no one else accesses my account when I'm finished
  As a User
  I want to log out

  Scenario: Logout
    Given a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And I am on the homepage
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "paulbjensen"
    And I fill in "password" with "123456"
    And I press "Login"
    Then the "login" modal should disappear
    And I should be on the dashboard page
    And I follow "Logout"
    Then I should be on the home page
    And I reload the page
    And I should be on the home page
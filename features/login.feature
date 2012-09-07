Feature: login
  In order to use the site
  As a user
  I want to login

  Scenario: Login (with username)
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

  Scenario: Login (with email)
    Given a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And I am on the homepage
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "paulbjensen@gmail.com"
    And I fill in "password" with "123456"
    And I press "Login"
    Then the "login" modal should disappear
    And I should be on the dashboard page

  Scenario: Fail to login (incorrect username/email)
    Given a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And I am on the homepage
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "bob"
    And I fill in "password" with "123456"
    And I press "Login"
    And I wait for a few seconds
    Then the "login" modal should not disappear
    And the field "password" placeholder should be "the user bob does not exist"

  Scenario: Fail to login (incorrect password)
    Given a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And I am on the homepage
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "paulbjensen"
    And I fill in "password" with "1234567"
    And I press "Login"
    And I wait for a few seconds
    Then the "login" modal should not disappear
    And the field "password" placeholder should be "password incorrect"

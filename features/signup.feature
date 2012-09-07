Feature: Signup
  In order to use Dashku
  As a user
  I want to signup

  Scenario: Signup to Dashku
    Given I am on the homepage
    And I follow "Signup"
    And the "signup" modal should appear
    And I fill in "username" with "paulbjensen"
    And I fill in "email" with "paulbjensen@gmail.com"
    And I fill in "password" with "123456"
    And I press "Signup"
    And the "signup" modal should disappear
    And there should be a user with username "paulbjensen"
    And I should be on the dashboard page

  Scenario: Fail to Signup (username already taken)
    Given a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    Given I am on the homepage
    And I follow "Signup"
    And the "signup" modal should appear
    And I fill in "username" with "paulbjensen"
    And I fill in "email" with "paulbjensen@gmail.com"
    And I fill in "password" with "123456"
    Then the field "username" should be ""
    And the field "username" placeholder should be "username is already taken"

  Scenario: Fail to Signup (email already taken)
    Given a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    Given I am on the homepage
    And I follow "Signup"
    And the "signup" modal should appear
    And I fill in "username" with "paulbjensen"
    And I fill in "email" with "paulbjensen@gmail.com"
    Then the field "email" should be ""
    And the field "email" placeholder should be "email is already taken"

  Scenario: Fail to Signup (password not long enough)
    Given a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    Given I am on the homepage
    And I follow "Signup"
    And the "signup" modal should appear
    And I fill in "username" with "paulbjensen"
    And I fill in "email" with "paulbjensen@gmail.com"
    And I fill in "password" with "12345"
    Then the field "password" should be ""
    And the field "password" placeholder should be "password is too short"
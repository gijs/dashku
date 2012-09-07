Feature: Dashboards
  In order to organise my widgets
  As a user
  I want to create, modify, and delete dashboards

  Scenario: Create a Dashboard
    Given a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And I am on the homepage
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "paulbjensen@gmail.com"
    And I fill in "password" with "123456"
    And I press "Login"
    And I wait for a few seconds
    And I click on the "Dashboards" menu item
    And I click on the "New Dashboard" menu item
    And I wait for a few seconds
    And the "new dashboard" modal should appear
    And I fill in "name" with "Account Sales"
    And I press "Create"
    Then the "new dashboard" modal should disappear
    And I should be on the dashboard page
    And I should see "Account Sales"
    And there should be an "Account Sales" item in the Dashboards menu list

  Scenario: Rename a Dashboard
    Given a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And I am on the homepage
    Given pending
    # We need to figure out how to fill in the contenteditable field and press the enter key without losing focus
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "paulbjensen@gmail.com"
    And I fill in "password" with "123456"
    And I press "Login"
    And I wait for a few seconds
    And I type "Server Monitor" into "Your Dashboard"
    And I wait for a few seconds
    And I should see "Server Monitor"
    And there should be an "Server Monitor" item in the Dashboards menu list
    And there should be a dashboard with the name "Server Monitor"

  Scenario: Resize the Dashboard
    Given a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And I am on the homepage
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "paulbjensen@gmail.com"
    And I fill in "password" with "123456"
    And I press "Login"
    And I wait for a few seconds
    And I click on the resize icon
    And the dashboard should be fluid length
    And the dashboard with name "Your Dashboard" should have a size of "fluid"
    And I click on the resize icon
    And the dashboard should be fixed length
    And the dashboard with name "Your Dashboard" should have a size of "fixed"

  Scenario: Delete the Dashboard
    Given a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And I am on the homepage
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "paulbjensen@gmail.com"
    And I fill in "password" with "123456"
    And I press "Login"
    And I wait for a few seconds
    And I click on the "Dashboards" menu item
    And I click on the "New Dashboard" menu item
    And I wait for a few seconds
    And the "new dashboard" modal should appear
    And I fill in "name" with "Account Sales"
    And I press "Create"
    Then the "new dashboard" modal should disappear
    And I should be on the dashboard page
    And I should see "Account Sales"
    And there should be an "Account Sales" item in the Dashboards menu list
    And I click on the "Dashboards" menu item
    And I click on the "Your Dashboard" menu item
    Then I should see "Your Dashboard"
    And I will confirm the dialog box
    And I click on the delete dashboard button
    And I intercept the dialog
    And I should see "Account Sales"
    And there should not be a dashboard with the name "Your Dashboard"
 
  @wip
  Scenario: Restyle the Dashboard
    Given a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And I am on the homepage
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "paulbjensen@gmail.com"
    And I fill in "password" with "123456"
    And I press "Login"
    And I wait for a few seconds
    When I click on the edit style button
    And I change the dashboard background colour to dark grey
    And I wait for a few seconds
    Then the dashboard background should be dark grey
    When I close the style editor
    And I wait for a few seconds
    Then the dashboard with name "Your Dashboard" should have css with a background of dark grey 
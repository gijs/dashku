Feature: Widgets
  In order to display my data in a meaningful way
  As a user
  I want to create, modify, and delete widgets

  Scenario: Create a widget (new)
    Given a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And I am on the homepage
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "paulbjensen@gmail.com"
    And I fill in "password" with "123456"
    And I press "Login"
    And I wait for a few seconds
    And I click on the "New Widget" menu item
    And the "new widget" modal should appear
    And I wait for a few seconds
    And I click on the "build widget" button
    Then the "new widget" modal should disappear
    And I should see 1 widget on the page
    And the dashboard with name "Your Dashboard" should have a widget with name "New Widget"

  Scenario: Create a widget (from template)
    Given a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And widget templates exist
    And I am on the homepage
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "paulbjensen@gmail.com"
    And I fill in "password" with "123456"
    And I press "Login"
    And I wait for a few seconds
    And I click on the "New Widget" menu item
    And the "new widget" modal should appear
    And I wait for a few seconds
    And I click on the "widget from template" button
    And I click on the "big number" button
    Then the "new widget" modal should disappear
    And I should see 1 widget on the page
    And the dashboard with name "Your Dashboard" should have a widget with name "Big Number"

  Scenario: Delete a widget
    Given a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And a widget exists with name "Widge" for dashboard "Your Dashboard"
    And I am on the homepage
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "paulbjensen@gmail.com"
    And I fill in "password" with "123456"
    And I press "Login"
    And I wait for a few seconds
    And I will confirm the dialog box
    And I click on the "delete widget" button
    And I intercept the dialog
    And I should see 0 widgets on the page
    And the dashboard with name "Your Dashboard" should not have any widgets
  
  Scenario: Resize a widget
    Given I am on the homepage
    And pending
    # The dragAndDrop command in selenium is giving a false positive (passes, but doesn't resize the element)
    # I'm going to seek help in order to fix this.
    And a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And a widget exists with name "Widge" for dashboard "Your Dashboard"
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "paulbjensen@gmail.com"
    And I fill in "password" with "123456"
    And I press "Login"
    And I wait for a few seconds
    And I drag the widget resize handle 600 pixels right and 400 pixels down 
    And I wait for a few seconds
    And the widget for dashboard "Your Dashboard" should have a width of 600 pixels, and a height of 400 pixels

  Scenario: Modify a Widget's HTML
    Given I am on the homepage
    And a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And a widget exists with name "Widge" for dashboard "Your Dashboard"
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "paulbjensen@gmail.com"
    And I fill in "password" with "123456"
    And I press "Login"
    And I wait for a few seconds
    And I click on the "edit widget" button
    And the "edit widget" modal should appear
    And I click on the "html" tab
    And I wait for a few seconds
    And I type "<div class='hi'>Hello World</div>" into the editor
    And I wait for a few seconds
    And I click on the "close editor" button
    And I wait for a few seconds
    And the widget for dashboard "Your Dashboard" should have the html "<div class='hi'>Hello World</div>"
 
  Scenario: Modify a Widget's CSS
    Given I am on the homepage
    And a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And a widget exists with name "Widge" for dashboard "Your Dashboard"
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "paulbjensen@gmail.com"
    And I fill in "password" with "123456"
    And I press "Login"
    And I wait for a few seconds
    And I click on the "edit widget" button
    And the "edit widget" modal should appear
    And I click on the "css" tab
    And I wait for a few seconds
    And I type ".content {background: none};" into the editor
    And I wait for a few seconds
    And I click on the "close editor" button
    And I wait for a few seconds
    And the widget for dashboard "Your Dashboard" should have the css ".content {background: none};"

  Scenario: Modify a Widget's JavaScript
    Given I am on the homepage
    And a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And a widget exists with name "Widge" for dashboard "Your Dashboard"
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "paulbjensen@gmail.com"
    And I fill in "password" with "123456"
    And I press "Login"
    And I wait for a few seconds
    And I click on the "edit widget" button
    And the "edit widget" modal should appear
    And I click on the "script" tab
    And I wait for a few seconds
    And I type "var b=1;" into the editor
    And I wait for a few seconds
    And I click on the "close editor" button
    And I wait for a few seconds
    And the widget for dashboard "Your Dashboard" should have the script "var b=1;"

  Scenario: Modify a Widget's JSON Payload
    Given I am on the homepage
    And a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And a widget exists with name "Widge" for dashboard "Your Dashboard"
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "paulbjensen@gmail.com"
    And I fill in "password" with "123456"
    And I press "Login"
    And I wait for a few seconds
    And I click on the "edit widget" button
    And the "edit widget" modal should appear
    And I click on the "json" tab
    And I wait for a few seconds
    And I clear the editor
    And I wait for a few seconds
    And I type some json into the editor
    And I wait for a few seconds
    And I click on the "close editor" button
    And I wait for a few seconds
    And the widget for dashboard "Your Dashboard" should have a JSON payload which contains that json

  Scenario: Reposition a Widget
    Given a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And a widget exists with name "Widget 1" for dashboard "Your Dashboard"
    And a widget exists with name "Widget 2" for dashboard "Your Dashboard"
    And I am on the homepage
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "paulbjensen@gmail.com"
    And I fill in "password" with "123456"
    And I press "Login"
    And I wait for a few seconds
    And I drag "Widget 1" 600 pixels to the right 
    And I wait for a few seconds
    Then widget with name "Widget 1" should have a position of "1"
    And widget with name "Widget 2" should have a position of "0"

  Scenario: Switch between JavaScript and CoffeeScript
    Given a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And a widget exists with name "Widget 1" for dashboard "Your Dashboard"
    And I am on the homepage
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "paulbjensen@gmail.com"
    And I fill in "password" with "123456"
    And I press "Login"
    And I wait for a few seconds
    And I click on the "edit widget" button
    And the "edit widget" modal should appear
    And I click on the "script" tab
    And I click on the "script" tab
    And the script tab should say "Coffeescript"
    And I clear the editor
    And I type in some coffeescript for the widget
    And I wait for a few seconds    
    And I click on the "close editor" button
    And I wait for a few seconds    
    And The widget for dashboard "Your Dashboard" should have the script type set to "coffeescript"
    And The widget for dashboard "Your Dashboard" should have the coffeescript as its script

  Scenario: Try out the Widget's load and transmit feature
    Given a user exists with username "paulbjensen" and email "paulbjensen@gmail.com" and password "123456"
    And a dashboard exists with name "Your Dashboard" for user "paulbjensen"
    And a widget exists with name "Widget 1" for dashboard "Your Dashboard"
    And I am on the homepage
    And I follow "Login"
    And the "login" modal should appear
    And I fill in "identifier" with "paulbjensen@gmail.com"
    And I fill in "password" with "123456"
    And I press "Login"
    And I wait for a few seconds
    And I click on the "edit widget" button
    And the "edit widget" modal should appear
    And I click on the "script" tab
    And I click on the "script" tab
    And I clear the editor
    And I wait for a few seconds
    And I load the editor with the modified script code
    And I wait for a few seconds
    And I click on the "json" tab
    And I clear the editor
    And I wait for a few seconds
    And I type some json into the editor
    And I wait for a few seconds
    And I click on the "test load" button
    And I wait for a few seconds
    And I wait for a few seconds
    And the widget on the page should contain "hello everyone" in its html
    And I click on the "test transmission" button
    And I wait for a few seconds
    And I wait for a few seconds
    And the widget on the page should contain "2" in its html
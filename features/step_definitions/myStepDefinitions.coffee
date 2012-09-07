fs = require "fs"

wrap = (funk, cb) ->
  funk.end (err) ->
    if err?
      cb.fail err
    else
      cb()

detectModal = (name, cb) ->
  character = switch name
    when "login"            then "#loginModal"
    when "signup"           then ".signupModal"
    when "cancel account"   then "#cancelAccountModal"
    when "new dashboard"    then "#newDashboardModal"
    when "new widget"       then "#newWidgetModal"
    when "edit widget"      then "#editor2"
    else throw new Error "Could not find modal for #{name}"
  cb character

detectButton = (name, cb) ->
  selector = switch name
    when "build widget"           then "//div[@id=\"buildWidget\"]"
    when "widget from template"   then "//div[@id=\"widgetFromTemplate\"]"
    when "big number"             then "//div[@class=\"name\" and contains(text(),'Big Number')]"
    when "delete widget"          then "//div[@class=\"delete\" and @title=\"delete widget\"]"
    when "edit widget"            then "//div[@class=\"edit\" and @title=\"edit widget\"]"
    when "close editor"           then "//a[@class=\"close\"]"
    when "test load"              then "//li[@id=\"load\"]"
    when "test transmission"      then "//li[@id=\"transmit\"]"
    else throw new Error "Could not find button for #{name}"
  cb selector

module.exports = ->

  @World = require("../support/world.coffee").World

  @Before (callback) ->
    User.remove {}, (err) ->
      Dashboard.remove {}, (err) ->
        WidgetTemplate.remove {}, (err) ->
          callback()

  @Given /^widget templates exist$/, (callback) ->
    fs.readdir "#{__dirname}/../../server/seed/widgetTemplates/", (err, files) ->
      if !err and files
        filesProcessed = 0
        for file in files
          widgetTemplate = new WidgetTemplate require "#{__dirname}/../../server/seed/widgetTemplates/#{file}"
          widgetTemplate.save (err,doc) ->
            if !err
              filesProcessed += 1
              callback() if filesProcessed is files.length
            else
              callback.fail err
  
  @After (callback) ->
    wrap @browser.chain.close(), callback

  @Given /^I am on the homepage$/, (callback) ->
    wrap @browser.chain.session().open('/'), callback

  @Given /^I follow "([^"]*)"$/, (link, callback) ->
    wrap @browser.chain.waitForElementPresent("link=#{link}").click("link=#{link}"), callback

  @Given /^I fill in "([^"]*)" with "([^"]*)"$/, (field, value, callback) ->
    wrap @browser.chain.fireEvent("//input[@name=\"#{field}\"]",'focus').type("//input[@name=\"#{field}\"]", value).fireEvent("//input[@name=\"#{field}\"]",'keyup').fireEvent("//input[@name=\"#{field}\"]",'blur'), callback

  @Given /^I press "([^"]*)"$/, (button, callback) ->
    wrap @browser.chain.fireEvent('//button[@type="submit"]','focus').click('//button[@type="submit"]'), callback

  # TODO - standardize on the use of either # or . for the login and signup modal css classes

  @Given /^the "([^"]*)" modal should appear$/, (name, callback) ->
    detectModal name, (character) =>
      wrap @browser.chain.waitForElementPresent("css=#{character}"), callback

  @Given /^the "([^"]*)" modal should disappear$/, (name, callback) ->
    detectModal name, (character) =>
      wrap @browser.chain.waitForElementNotPresent("css=#{character}"), callback

  @Given /^the "([^"]*)" modal should not disappear$/, (name, callback) ->
    character = if name is "login" then "#loginModal" else ".signupModal"  
    wrap @browser.chain.waitForElementPresent("css=#{character}"), callback

  @Given /^there should be a user with username "([^"]*)"$/, (username, callback) ->
    User.find {username}, (err, docs) ->
      if !err? and docs.length is 1
        callback()
      else
        callback.fail "Expected there to be 1 user record with username #{username}, but found #{docs.length}"

  # TODO - refactor these 3 common step definitions

  @Given /^I should be on the dashboard page$/, (callback) ->
    wrap @browser.chain.waitForElementPresent('css=.dashboard'), callback

  @Given /^I should be on the home page$/, (callback) ->
    wrap @browser.chain.waitForElementPresent('css=.homepage'), callback

  @Given /^I should be on the account page$/, (callback) ->
    wrap @browser.chain.waitForElementPresent('css=.account'), callback

  @Given /^I reload the page$/, (callback) ->
    wrap @browser.chain.refresh(), callback

  @Given /^pending$/, (callback) ->
    callback.pending()

  @Given /^a user exists with username "([^"]*)" and email "([^"]*)" and password "([^"]*)"$/, (username, email, password, callback) ->
    user = new User {username, email, password}
    user.save (err, doc) ->
      if err?
        callback.fail err
      else
        callback()

  @Given /^a dashboard exists with name "([^"]*)" for user "([^"]*)"$/, (name, username, callback) ->
    User.findOne {username}, (err, user) ->
      callback.fail(err) if err?
      dashboard = new Dashboard {name: name, userId: user._id}
      dashboard.save (err, doc) ->
        if err?
          callback.fail err
        else
          callback()

  @Then /^the field "([^"]*)" should be "([^"]*)"$/, (field, value, callback) ->
    wrap @browser.chain.assertValue("//input[@name=\"#{field}\"]", value), callback

  @Then /^the field "([^"]*)" placeholder should be "([^"]*)"$/, (field, placeholder, callback) ->
    wrap @browser.chain.assertAttribute("//input[@name=\"#{field}\"]@placeholder", placeholder), callback

  @Then /^I wait for a few seconds$/, (callback) ->
    setTimeout ->
      callback()
    , 2000

  @Then /^there should not be a user with username "([^"]*)"$/, (username, callback) ->
    User.find {username}, (err, docs) ->
      if docs.length is 0
        callback()
      else
        callback.fail "There shouldn't be a user with username #{username}"

  @Given /^I click on the "([^"]*)" menu item$/, (item, callback) ->
    wrap @browser.chain.click("//span[contains(text(),'#{item}')]"), callback    

  @Then /^I should see "([^"]*)"$/, (content, callback) ->
    wrap @browser.chain.assertTextPresent(content), callback 

  @Then /^there should be an "([^"]*)" item in the Dashboards menu list$/, (item, callback) ->
    wrap @browser.chain.assertElementPresent("//span[contains(text(),'#{item}')]"), callback

  @Given /^I type "([^"]*)" into "([^"]*)"$/, (newText, oldText, callback) ->
    wrap @browser.chain.focus("//h1[contains(text(),'#{oldText}')]").type("//h1[contains(text(),'#{oldText}')]", "#{newText}\\13"), callback

  @Given /^I press the Enter key$/, (callback) ->
    callback.pending()

  @Given /^there should be a dashboard with the name "([^"]*)"$/, (arg1, callback) ->
    callback.pending()

  @Given /^I click on the resize icon$/, (callback) ->
    wrap @browser.chain.click("//a[@id=\"screenWidth\"]"), callback

  @Given /^the dashboard should be fluid length$/, (callback) ->
    wrap @browser.chain.waitForElementPresent('css=.row-fluid'), callback

  @Given /^the dashboard should be fixed length$/, (callback) ->
    wrap @browser.chain.waitForElementPresent('css=.row'), callback

  @Given /^the dashboard with name "([^"]*)" should have a size of "([^"]*)"$/, (name, screenWidth, callback) ->
    Dashboard.findOne {name, screenWidth}, (err, dashboard) ->
      if err?
        callback.fail err
      else
        if !dashboard?
          callback.fail "No dashboard found with name: #{name} and screenWidth: #{screenWidth}"
        else
          callback()

  @Then /^I click on the delete dashboard button$/, (callback) ->
    wrap @browser.chain.click("//a[@id=\"deleteDashboard\"]"), callback

  @Then /^I will confirm the dialog box$/, (callback) ->
    wrap @browser.chain.chooseOkOnNextConfirmation(), callback

  @Then /^I intercept the dialog$/, (callback) ->
    wrap @browser.chain.getConfirmation(), callback

  @Then /^there should not be a dashboard with the name "([^"]*)"$/, (name, callback) ->
    Dashboard.find {name}, (err, dashboards) ->
      if err?
        callback.fail err
      else
        if dashboards.length is 0
          callback()
        else
          callback.fail "No dashboard found with name: #{name} and screenWidth: #{screenWidth}"

  # TODO - refactor these 2 steps with logic to match the passed name to the selector

  @When /^I click on the edit style button$/, (callback) ->
    wrap @browser.chain.click("//a[@id=\"styleDashboard\"]"), callback

  @Given /^I click on the "([^"]*)" button$/, (name, callback) ->
    detectButton name, (selector) =>
      wrap @browser.chain.waitForElementPresent(selector).click(selector), callback

  @When /^I change the dashboard background colour to dark grey$/, (callback) ->
    wrap @browser.chain.focus("//textarea").type("//textarea", "\n\nbody {background:#111;}"), callback

  @Then /^the dashboard background should be dark grey$/, (callback) ->
    wrap @browser.chain.assertElementPresent("//style[@id=\"dashboardStyle\" and contains(text(), 'body {background:#111;}')]"), callback

  @When /^I close the style editor$/, (callback) ->
    wrap @browser.chain.click("//a[@class=\"close\"]"), callback

  @Then /^the dashboard with name "([^"]*)" should have css with a background of dark grey$/, (name, callback) ->
    Dashboard.find {name}, (err, dashboards) ->
      if err?
        callback.fail err
      else
        dashboard = dashboards[0]
        console.log(dashboards.length)
        if dashboard.css.match(/body {background:#111;}/)?
          callback()
        else
          callback.fail "The dashboard does not have that style"

  @Then /^I should see (\d+) widget on the page$/, (numberOfWidgets, callback) ->
    wrap @browser.chain.verifyElementPresent("//div[@class=\"widget\"]"), callback

  @Then /^the dashboard with name "([^"]*)" should have a widget with name "([^"]*)"$/, (name, widgetName, callback) ->
    Dashboard.findOne {name}, (err, dashboard) ->
      if err?
        callback.fail err
      else
        if dashboard.widgets[0]? and dashboard.widgets[0].name is widgetName
          callback()
        else
          callback.fail "No dashboard found with name: #{name} and a widget with name: #{widgetName}"

  @Given /^I should see (\d+) widgets on the page$/, (numberOfWidgets, callback) ->
    wrap @browser.chain.verifyElementNotPresent("//div[@class=\"widget\"]"), callback

  @Given /^the dashboard with name "([^"]*)" should not have any widgets$/, (name, callback) ->
    Dashboard.findOne {name}, (err, dashboard) ->
      if err?
        callback.fail err
      else
        if dashboard.widgets.length is 0
          callback()
        else
          callback.fail "The dashboard has widgets when none were expected"

  @Given /^a widget exists with name "([^"]*)" for dashboard "([^"]*)"$/, (widgetName, name, callback) ->
    Dashboard.findOne {name}, (err, dashboard) ->
      if err?
        callback.fail err
      else
        User.find {_id: dashboard.userId}, (err, user) ->
          # TODO - find out why user is sometimes undefined
          if err?
            callback.fail err
          else
            widgetController.create {dashboardId: dashboard._id, name: widgetName}, user, (res) ->
              if res.status is 'success'
                callback() 
              else
                callback.fail res.reason

  @Given /^I drag the widget resize handle (\d+) pixels right and (\d+) pixels down$/, (pixelsRight, pixelsDown, callback) ->
    wrap @browser.chain.dragAndDrop("//div[@class=\"ui-resizable-handle ui-resizable-se ui-icon ui-icon-gripsmall-diagonal-se\"]","+#{pixelsRight},+#{pixelsDown}"), callback

  @Given /^the widget for dashboard "([^"]*)" should have a width of (\d+) pixels, and a height of (\d+) pixels$/, (name, width, height, callback) ->
    Dashboard.findOne {name}, (err, dashboard) ->
      if err?
        callback.fail err
      else
        widget = dashboard.widgets[0]
        if widget.width is width and widget.height is height
          callback()
        else
          callback.fail "The widget's width and height were supposed to be #{width}x#{height}, but were #{widget.width}x#{widget.height}"

  @Given /^I click on the "([^"]*)" tab$/, (tabName, callback) ->
    wrap @browser.chain.click("//li[@id=\"#{tabName}\"]"), callback

  @Given /^I type "([^"]*)" into the editor$/, (html, callback) ->
    wrap @browser.chain.focus("//textarea").type("//textarea",html), callback

  @Given /^I type some json into the editor$/, (callback) ->
    json  = "{\"version\":\"2\"}"
    wrap @browser.chain.focus("//textarea").type("//textarea",json), callback

  @Given /^the widget for dashboard "([^"]*)" should have the html "([^"]*)"$/, (name, html, callback) ->
    Dashboard.findOne {name}, (err, dashboard) ->
      if err?
        callback.fail err
      else
        widget = dashboard.widgets[0]
        if widget.html.match(html)?
          callback()
        else
          callback.fail "The widget's html was supposed to be #{html}, but is #{widget.html}"

  @Given /^the widget for dashboard "([^"]*)" should have the css "([^"]*)"$/, (name, css, callback) ->
    Dashboard.findOne {name}, (err, dashboard) ->
      if err?
        callback.fail err
      else
        widget = dashboard.widgets[0]
        if widget.css.match(css)?
          callback()
        else
          callback.fail "The widget's html was supposed to be #{css}, but is #{widget.css}"

  @Given /^the widget for dashboard "([^"]*)" should have the script "([^"]*)"$/, (name, script, callback) ->
    Dashboard.findOne {name}, (err, dashboard) ->
      if err?
        callback.fail err
      else
        widget = dashboard.widgets[0]
        if widget.script.match(script)?
          callback()
        else
          callback.fail "The widget's script was supposed to include #{script}, but is #{widget.script}"

  @Given /^I clear the editor$/, (callback) ->
    wrap @browser.chain.getEval("window.editor2.editor.setValue('');"), callback

  @Given /^the widget for dashboard "([^"]*)" should have a JSON payload which contains that json$/, (name, callback) ->
    Dashboard.findOne {name}, (err, dashboard) ->
      if err?
        callback.fail err
      else
        widget = dashboard.widgets[0]
        if JSON.parse(widget.json).version is '2'
          callback()
        else
          callback.fail "The widget's json was supposed to include version:2, but is #{widget.json}"

  # Note - this drag and drop selector is currently matching on the first content class, not by widget name
  @Given /^I drag "([^"]*)" (\d+) pixels to the right$/, (element, pixelsRight, callback) ->
    Dashboard.findOne {}, (err, dashboard) =>
      for widget in dashboard.widgets
        if widget.name is element
          wrap @browser.chain.dragAndDrop("//div[@class=\"content\"]","+#{pixelsRight},+0"), callback

  @Then /^widget with name "([^"]*)" should have a position of "([^"]*)"$/, (name, position, callback) ->
    Dashboard.findOne {}, (err, dashboard) =>
      for widget in dashboard.widgets
        if widget.name is name
          if widget.position - new Number(position) == 0
            callback()
          else
            callback.fail "The widget with name #{name} should have a position of #{position}, but has a position of #{widget.position}"

  @Given /^the script tab should say "([^"]*)"$/, (text, callback) ->
    wrap @browser.chain.assertElementPresent("//li[@id=\"script\" and contains(text(),'#{text}')]"), callback

  @Given /^I type in some coffeescript for the widget$/, (callback) ->
    # type some CoffeeScript into the editor's textarea
    coffeescript = "
\n@on 'load', (data) =>
\n  @widget.append(\"<div id='message'>awaiting transmission</div>\").hide().fadeIn 'slow'
\n
\n@on 'transmission', (data) =>
\n  message = @widget.find '#message'
\n  message.text(data.message).hide().fadeIn()"
    wrap @browser.chain.focus("//textarea").type("//textarea",coffeescript), callback

  @Then /^The widget for dashboard "([^"]*)" should have the coffeescript as its script$/, (name, callback) ->
    coffeescript = "
\n@on 'load', (data) =>
\n  @widget.append(\"<div id='message'>awaiting transmission</div>\").hide().fadeIn 'slow'
\n
\n@on 'transmission', (data) =>
\n  message = @widget.find '#message'
\n  message.text(data.message).hide().fadeIn()"
    Dashboard.findOne {name}, (err, dashboard) ->
      if dashboard.widgets[0].script is coffeescript
        callback()
      else
        callback.fail "The widget does not have the same coffeescript as expected"

  @Then /^The widget for dashboard "([^"]*)" should have the script type set to "([^"]*)"$/, (name, scriptType, callback) ->
    Dashboard.findOne {name}, (err, dashboard) ->
      if dashboard.widgets[0].scriptType is scriptType
        callback()
      else
        callback.fail "The widget does not have the script type set to coffee"

  @Given /^I load the editor with the modified script code$/, (callback) ->
    # type some CoffeeScript into the editor's textarea
    coffeescript = "
\n@on 'load', (data) =>
\n  @widget.append(\"<div id='message'>hello everyone</div>\")
\n
\n@on 'transmission', (data) =>
\n  message = @widget.find '#message'
\n  message.text(data.version)"
    wrap @browser.chain.focus("//textarea").type("//textarea",coffeescript), callback

  @Given /^the widget on the page should contain "([^"]*)" in its html$/, (content, callback) ->
    wrap @browser.chain.assertElementPresent("//div[@id=\"message\" and contains(text(),'#{content}')]"), callback
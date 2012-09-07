#### StateManager
#
# This is a view-rendering helper class which allows me to render different html states for
# a given section on the page.
#
# To give an example, the account section in the top-right of the application has 2 states:
#
# - The homepage state, where we are logged out, and so a html template with a login link 
#   is rendered
#
# - The app state, where we are logged in, so a html template with a link to the user's 
#   account and the logout link are displayed.
#
# USAGE
#
#    accountState = new StateManager('JQUERY_SELECTOR_FOR_SECTION')
#    
#    accountState.addState 'STATE_NAME', -> jQuery('JQUERY_SELECTOR_FOR_SECTION').html HTML_TEMPLATE_FOR_HOMEPAGE
#
#
# In the case of app, we pass a JSON object to it containing a username, so that we can render it in the template
#
#
#    accountState.addState 'STATE_NAME', (data) -> jQuery('JQUERY_SELECTOR_FOR_SECTION').html(HTML_TEMPLATE_FOR_HOMEPAGE_WITH_RENDER(JSON_OBJECT))
#
# When we then want to render the a state i.e (the homepage), we call:
#
#    accountState.setState 'STATE_NAME'
#
# If the state receives data to render into the html template, we call:
#
#    accountState.setState 'STATE_NAME', JSON_OBJECT
#
class window.StateManager
  constructor: (@domId) ->
    @currentState = null
    @states = {}
  
  # Adds the state to the list of states for the stateManager class
  addState: (domClass, render) ->
    @states[domClass] = render

  # Sets the state. Will fade out the existing state if one has 
  # been set before, and fade in the new one.
  setState: (state, data=null) ->
    if @currentState?
      jQuery("#{@domId} .#{@currentState}").fadeOut 'slow', =>
        @states[state] data
        jQuery("#{@domId} .#{state}").hide().fadeIn 'slow'
    else
      @states[state] data
      jQuery("#{@domId} .#{state}").hide().fadeIn 'slow'
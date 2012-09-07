# Enable the user to submit the login form if the fields are valid
checkLoginFormIsReady = ->
  if jQuery('#loginModal input[name="password"]').val().length > 5 && jQuery('#loginModal input[name="identifier"]').val().length > 0
    jQuery('#loginModal button').removeAttr "disabled"
  else
    jQuery('#loginModal button').attr "disabled", "disabled"  


# Bind events when the login form is visible
jQuery(document).on 'shown', '#loginModal', ->
  jQuery('#loginModal button').attr "disabled", "disabled"
  jQuery('#loginModal').on 'hidden', -> jQuery(@).remove()

  jQuery('#loginModal input[name="identifier"]').keyup -> checkLoginFormIsReady()
  jQuery('#loginModal input[name="password"]').keyup -> checkLoginFormIsReady()  

# Remove the modal once it is hidden
jQuery(document).on 'hidden', '#loginModal', ->
  jQuery(@).remove()

# Login the user when they submit the login form
jQuery(document).on 'submit', '#loginModal form', ->
  ss.rpc 'authentication.login', serializeFormData(@), (response) ->
    if response.status is "success"
      jQuery('#loginModal').modal 'hide'
      showLoginState username: response.user.username
    else
      jQuery('#loginModal input[name="password"]').val('').attr('placeholder', response.reason).parent().addClass('control-group error')
      jQuery('#loginModal .forgotPassword').removeClass('hidden');
  return false

# Display the login modal when clicking the login button
jQuery(document).on 'click', 'a#login', (event) ->
  jQuery(ss.tmpl.loginModal.r()).modal()   

# change the page state to that of the homepage
jQuery(document).on 'click', 'a#logout', (event) ->
  ss.rpc 'authentication.logout', (response) ->
    if response.status is 'success'
      showLogoutState()
    else
      alert "There was an error - #{response.reason}"

# Clear the error style when the user focuses on the password field
jQuery(document).on 'focus', '#loginModal input[name="password"]', (event) ->
  jQuery(@).parent().removeClass('control-group error')

# Send an email for the forgotten password issue
jQuery(document).on 'click', '.forgotPassword a', ->
  element = jQuery(@)
  ss.rpc 'authentication.forgotPassword', jQuery('#loginModal input[name="identifier"]').val(), (response) ->
    if response.status is 'success'
      element.replaceWith("<span>An email has been sent to you.</span>")
    else
      # tell the user that an error occurred, with the error message in question.
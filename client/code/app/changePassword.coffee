# A helper function to render
# the change password page state
window.showChangePasswordState = (token) ->
  jQuery(ss.tmpl['changePasswordModal'].render(token: token)).modal()

# A helper function to validate
# that the change password form
# is valid, and render errors if
# it isn't.
checkChangePasswordFormIsReady = ->
  if jQuery('#changePasswordModal input[name="password"]').val().length > 5
    jQuery('#changePasswordModal button').removeAttr "disabled"
  else
    jQuery('#changePasswordModal button').attr "disabled", "disabled"  

# Create event bindings on the change password modal
# being shown
jQuery(document).on 'shown', '#changePasswordModal', ->
  jQuery('#changePasswordModal button').attr "disabled", "disabled"
  jQuery('#changePasswordModal').on 'hidden', -> jQuery(@).remove()
  jQuery('#changePasswordModal input[name="password"]').keyup -> checkChangePasswordFormIsReady()  

# Handle the change password form submission
jQuery(document).on 'submit', '#changePasswordModal form', ->
  ss.rpc 'authentication.changePassword', serializeFormData(@), (response) ->
    if response.status is "success"
      jQuery('#changePasswordModal').modal 'hide'
      showLogoutState()
      alert "Password changed. You can login now"
    else
      jQuery('#changePasswordModal').modal 'hide'
      alert "There was an error - #{response.reason}"
      # TODO - handle error messages in a better fashion
  return false
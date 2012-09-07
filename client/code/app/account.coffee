#### Change Email ####


# Render the account page state if the user 
# clicks on their name
jQuery(document).on 'click', 'a#name', ->
  ss.rpc 'authentication.account', (response) ->
    if response.status is 'success'
      mainState.setState 'account', response.user
    else
      showLogoutState()

# A helper function which validates
# the change email address form, and 
# handles error rendering.
checkChangeEmailFormIsReady = ->
  jQuery('#changeEmailModal input[name="email"]').parent().removeClass('control-group error')
  if jQuery('#changeEmailModal input[name="email"]').val().match('@')?
    jQuery('#changeEmailModal button').removeAttr "disabled"
  else
    jQuery('#changeEmailModal button').attr "disabled", "disabled"

# Change email dialogue modal
jQuery(document).on 'click', '#changeEmail', ->
  jQuery(ss.tmpl['account-changeEmailModal'].r()).modal()   

# Create Event bindings on the change email modal being shown 
jQuery(document).on 'shown', '#changeEmailModal', ->
  jQuery('#changeEmailModal button').attr "disabled", "disabled"
  jQuery('#changeEmailModal').on 'hidden', -> jQuery(@).remove()
  jQuery('#changeEmailModal input[name="email"]').keyup -> checkChangeEmailFormIsReady()
  jQuery('#changeEmailModal input[name="email"]').blur -> checkChangeEmailFormIsReady()

# Event binding on the change email form being submitted
jQuery(document).on 'submit', '#changeEmailModal form', ->
  ss.rpc 'authentication.changeEmail', serializeFormData(@), (response) ->
    if response.status is "success"
      jQuery('#changeEmailModal').modal 'hide'
      ss.rpc 'authentication.account', (response) ->
        if response.status is 'success'
          mainState.setState 'account', response.user
        else
          showLogoutState()
    else
      jQuery('#changeEmailModal input[name="email"]').val('').attr('placeholder', response.reason).parent().addClass('control-group error')

  return false


#### Change Password ####


# A helper function which validates
# the fields in the change password form,
# and handles error rendering
checkChangeAccountPasswordFormIsReady = ->
  currentPassword = jQuery('#changeAccountPasswordModal input[name="currentPassword"]').val()
  newPassword     = jQuery('#changeAccountPasswordModal input[name="newPassword"]').val()
  jQuery('#changeAccountPasswordModal input').parent().removeClass('control-group error')
  if currentPassword.length > 5 and newPassword.length > 5
    jQuery('#changeAccountPasswordModal button').removeAttr "disabled"
  else
    jQuery('#changeAccountPasswordModal button').attr "disabled", "disabled"

# Event binding to display the change password modal
jQuery(document).on 'click', '#changePassword', ->
  jQuery(ss.tmpl['account-changePasswordModal'].r()).modal()   

# create Event bindings when the change 
# account password modal is shown
jQuery(document).on 'shown', '#changeAccountPasswordModal', ->
  jQuery(@).find('button').attr "disabled", "disabled"
  jQuery(@).on 'hidden', -> jQuery(@).remove()
  jQuery(@).find('input[name="newPassword"]').keyup -> checkChangeAccountPasswordFormIsReady()
  jQuery(@).find('input[name="newPassword"]').blur -> checkChangeAccountPasswordFormIsReady()

# Handle the submission of the change password form
jQuery(document).on 'submit', '#changeAccountPasswordModal form', ->
  ss.rpc 'authentication.changeAccountPassword', serializeFormData(@), (response) ->
    if response.status is "success"
      jQuery('#changeAccountPasswordModal').modal 'hide'
      alert "Password changed"
    else
      jQuery('#changeAccountPasswordModal input').val('').attr('placeholder', response.reason).parent().addClass('control-group error')
  return false


#### Cancel Account ####


# A helper function for the cancel account form.
# Checks that the values in the form are valid,
# and performs error rendering.
checkCancelAccountFormIsReady = ->
  jQuery('#cancelAccountModal input[name="password"]').parent().removeClass('control-group error')
  if jQuery('#cancelAccountModal input[name="password"]').val().length > 5
    jQuery('#cancelAccountModal button').removeAttr "disabled"
  else
    jQuery('#cancelAccountModal button').attr "disabled", "disabled"

# Render the cancel account modal when the link is clicked
jQuery(document).on 'click', '#cancelAccount', ->
  jQuery(ss.tmpl['account-cancelAccountModal'].r()).modal()   

# Create event bindings on the cancel account form
jQuery(document).on 'shown', '#cancelAccountModal', ->
  jQuery('#cancelAccountModal button').attr "disabled", "disabled"
  jQuery('#cancelAccountModal').on 'hidden', -> jQuery(@).remove()
  jQuery('#cancelAccountModal input[name="password"]').keyup -> checkCancelAccountFormIsReady()
  jQuery('#cancelAccountModal input[name="password"]').blur -> checkCancelAccountFormIsReady()

# Handle the cancel account form submission
jQuery(document).on 'submit', '#cancelAccountModal form', ->
  ss.rpc 'authentication.cancelAccount', serializeFormData(@), (response) ->
    if response.status is "success"
      jQuery('#cancelAccountModal').modal 'hide'
      showLogoutState()
    else
      jQuery('#cancelAccountModal input[name="password"]').val('').attr('placeholder', response.reason).parent().addClass('control-group error')
  return false
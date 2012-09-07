# Enable the user to submit the new dashboard form if there is a name
checkDashboardFormIsReady = ->
  if jQuery('#newDashboardModal input[name="name"]').val().length > 0
    jQuery('#newDashboardModal button').removeAttr "disabled"
  else
    jQuery('#newDashboardModal button').attr "disabled", "disabled"  

# Render the new dashboard modal
jQuery(document).on 'click', 'a#newDashboard', (event) ->
  jQuery(ss.tmpl['dashboard-newModal'].r()).modal()   

# Bind events when the login form is visible
jQuery(document).on 'shown', '#newDashboardModal', ->
  jQuery(@).find('button').attr "disabled", "disabled"
  jQuery(@).on 'hidden', -> jQuery(@).remove()
  jQuery(@).find('input[name="name"]').keyup -> checkDashboardFormIsReady()  

# User submits the new dashboard form
jQuery(document).on 'submit', '#newDashboardModal form', ->
  ss.rpc 'dashboard.create', serializeFormData(@), (response) ->
    if response.status is "success"
      jQuery('#newDashboardModal').modal 'hide'
      Dashboard.select response.dashboard
    else
      jQuery('#newDashboardModal input[name="name"]').val('').attr('placeholder', response.reason).parent().addClass('control-group error')
  return false

# Clear the error style when the user focuses on the password field
jQuery(document).on 'focus', '#newDashboardModal input[name="name"]', (event) ->
  jQuery(@).parent().removeClass('control-group error')

# Display the dashboard on the page
jQuery(document).on 'click', 'a.showDashboard', ->
  Dashboard.select jQuery(@).attr('data-id')

# Record the previous value, in case the user decides not to update the field
jQuery(document).on 'focus', 'h1.name', (event) ->
  jQuery(@).attr 'data-previousName', jQuery(@).text()

# Revert to the previous value, unless the user has pressed the enter key to submit the change
jQuery(document).on 'blur', 'h1.name', (event) ->
  unless window.dontRevert?
    jQuery(@).text jQuery(@).attr 'data-previousName'
  else
    window.dontRevert = undefined

# Update the dashboard with the new name
jQuery(document).on 'keypress', 'h1.name', (event) ->
  if event.keyCode is 13
    window.dontRevert = true
    jQuery(@).blur()
    _id = jQuery('#widgets').attr('data-dashboardId')
    name = jQuery(@).text()
    ss.rpc 'dashboard.update', {_id,name}
    false
    
# Delete dashboard confirmation dialog and response handler    
jQuery(document).on 'click', 'a#deleteDashboard', ->
  if confirm("Delete the dashboard?")
    ss.rpc 'dashboard.delete', Dashboard.selected._id, (response) ->
      jQuery('#editDashboardModal').modal 'hide'
      alert response.reason if response.status isnt 'success'

# Make the dashboard fluid width
jQuery(document).on 'click', 'a#screenWidth', ->
  newScreenWidth = if Dashboard.selected.screenWidth is 'fixed' then 'fluid' else 'fixed'
  ss.rpc 'dashboard.update', _id: Dashboard.selected._id, screenWidth: newScreenWidth

# Load the CSS editor for the dashboard
jQuery(document).on 'click', 'a#styleDashboard', ->
  cssEditor.init Dashboard.selected


#### SS event bindings ####


# A new dashboard has been created.
# Add it to the data bucket,
# and render it in the menu items list
ss.event.on 'dashboardCreated', (dashboard, channelName) ->
  Dashboard.add dashboard
  jQuery('#dashboardMenuItems').prepend ss.tmpl['dashboard-dashboardMenuItem'].render dashboard
  sortDashboardMenuList('ul#dashboardMenuItems', 'li[data-dashboardid]')

# An existing dashboard has been updated.
# Update the data bucket,
# update the dashboards menu list item, and
# update the view rendering of that dashboard
# if it is currently selected.
ss.event.on 'dashboardUpdated', (dashboard, channelName) ->
  Dashboard.update dashboard
  if Dashboard.selected? and Dashboard.selected._id is dashboard._id
    Dashboard.selected = dashboard
    jQuery('.dashboard h1.name').text dashboard.name
    renderCSS dashboard.css
    renderScreenSize dashboard.screenWidth
  jQuery('#dashboardMenuItems').find("li[data-dashboardId='#{dashboard._id}']").replaceWith ss.tmpl['dashboard-dashboardMenuItem'].render dashboard
  sortDashboardMenuList('ul#dashboardMenuItems', 'li[data-dashboardid]')

# An existing dashboard has been deleted.
# Remove the dashboard from the data bucket, 
# remove it's item from the dashboards menu,
# and deselect it if it is currently on display.
ss.event.on 'dashboardDeleted', (dashboardId, channelName) ->
  Dashboard.remove dashboardId  
  jQuery('#dashboardMenuItems').find("li[data-dashboardId='#{dashboardId}']").remove()
  Dashboard.select Dashboard.all[0] if Dashboard.selected._id is dashboardId
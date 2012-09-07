#### App ####
#
# The application code starts with a call to see
# if the url contains a forgotten password token.
#
# If it does, we pass that token to the server,
# and check if it is valid. If it's valid, we 
# allow the user to change their password.
#
if document.location.href.match('fptoken')?
  token = document.location.href.split("=")[1]
  ss.rpc 'authentication.loadChangePassword', (token), (response) ->
    if response.status is 'success'
      showChangePasswordState(response.token)
    else
      jQuery('.container').append ss.tmpl.alert.render title: "This token is invalid", message: "It looks like you've already used it before"
      showLogoutState()    
else
  # The application url does not contain a 
  # forgotten password token. We can load the
  # application as normal.


  if document.location.href.match('dashboard')?
    
    # Render the dashboard in view-only mode
    $('.navbar').hide()
    id = document.location.href.split("=")[1]

    # We define a special bucket just for the view only-dashboard
    DashboardViewWidget = new Bucket
      loadFunction: (cb) ->
        # Call the server to fetch the dashboard
        ss.rpc 'dashboard.externalGet', id, (response) ->
          if response.status is "success"
            response.dashboard.widgets.sort (a,b) -> a.position - b.position
            mainState.setState 'dashboardView', response.dashboard
            renderScreenSize response.dashboard.screenWidth
            cb response.dashboard.widgets
          else
            alert "There was an error - #{response.reason}"
          # TODO - handle error responses in a better fashion    

      # Bind the widget event Emitter for each widget added to the dashboard's data model.
      preAddCb: (widget, cb) ->
        widget.eventEmitter = new EE code: widget.script, id: widget._id, scriptType: widget.scriptType
        cb widget

      # Bind the widget event Emitter for each widget added to the dashboard's data model.
      postUpdateCb: (widget, cb) ->
        widget.eventEmitter = new EE code: widget.script, id: widget._id, scriptType: widget.scriptType
        cb widget

    # Call the load function on the DashboardViewWidget bucket
    DashboardViewWidget.load()

    # Bind on the transmission event, where a widget may receive data 
    ss.event.on 'transmission', (data, channelName) ->
      widget = DashboardViewWidget.find(data._id)
      widget.eventEmitter.emit('transmission', data) if widget?

    # Bind on the widget created event, where we render that widget, if it
    # belongs to the dashboard that we are displaying
    ss.event.on 'widgetCreated', (data, channelName) ->
      if id is data.dashboardId
        DashboardViewWidget.add data.widget, ->
          jQuery('#widgets').append ss.tmpl['dashboardView-widget'].render data.widget
          widget = DashboardViewWidget.find data.widget._id
          widget.eventEmitter = new EE code: widget.script, id: widget._id, scriptType: widget.scriptType

    # Bind on the widget deleted event, where we remove the widget
    # from the view from the data bucket, and the view, if it is in
    # either of those.
    #
    # TODO - find a nicer way to bind view rendering to data model changes. 
    ss.event.on 'widgetDeleted', (data, channelName) ->
      DashboardViewWidget.remove data.widgetId, ->
        widget = jQuery('#widgets').find(".widget[data-id='#{data.widgetId}']")
        widget.fadeOut 'slow', -> widget.remove()

    # Bind on the widget updated event, where we update the widget,
    # if it happens to be in this dashboard.
    ss.event.on 'widgetUpdated', (data, channelName) ->
      widget = DashboardViewWidget.find(data.widget._id)

      if widget?
        if onlyNameChanged(widget, data.widget)
          # We just make a cosmetic change to the view element
          jQuery('#widgets').find(".widget[data-id='#{data.widget._id}']").find('.header').text data.widget.name
        else
          widgetView = jQuery('#widgets').find(".widget[data-id='#{data.widget._id}']")
          # Replace the widget's html piece 
          widgetView.find('.content').html(jQuery(ss.tmpl['dashboard-widget'].render(data.widget)).find('.content').html())
          # Replace the widget's scoped CSS
          widgetView.find('style').text data.widget.scopedCSS
          # Update the widget's width and height, if adjusted
          widgetView.css width: "#{data.widget.width}px", height: "#{data.widget.height}px"
          # Update the widget in the Bucket. As noted before, it would be nice to tie
          # the view updates to data model updates. Will implement this pattern in the
          # near future. 
          DashboardViewWidget.update data.widget

    # Bind on the widget's positions being updated.
    ss.event.on 'widgetPositionsUpdated', (data, channelName) ->
      if id is data._id
        for widget in DashboardViewWidget.all
          widget.position = data.positions[widget._id]

        DashboardViewWidget.all.sort (a,b) -> a.position - b.position

        # TODO - refactor, as duplicated in widgets.coffee
        for widget in DashboardViewWidget.all
          index = DashboardViewWidget.all.indexOf(widget)
          if index < DashboardViewWidget.all.length
            jQuery(".widget[data-id='#{widget._id}']")
            .after(jQuery(".widget[data-id='#{DashboardViewWidget.all[index+1]._id}']")) 

    # Bind on the dashboard being update
    ss.event.on 'dashboardUpdated', (dashboard, channelName) ->
      if id is dashboard._id
        jQuery('.dashboardView h1.name').text dashboard.name
        renderScreenSize dashboard.screenWidth
        renderCSS dashboard.css

    # Bind on the dashboard being deleted
    ss.event.on 'dashboardDeleted', (dashboardId, channelName) ->
      if id is dashboardId
        alert "This dashboard has been deleted"

  else
    # Render the app in normal model
    ss.rpc 'authentication.signedIn', (response) ->
      if response.status is 'success'
        showLoginState username: response.user.username
      else    
        showLogoutState()

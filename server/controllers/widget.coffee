#### The Widget controller ####


# TODO - make this shared between client and server, in too many places ATM
scopeCSS = (text,id) ->
  lines = text.split("\n")
  for line in lines
    text = text.replace(line, ".widget[data-id='#{id}'] #{line}") if line.match(/{/) isnt null
  text

createAWidgetDry = (dashboard, data, user, cb) ->
  dashboard.widgets.push _.extend(data, {userId: user._id, dashboardId: undefined})
  dashboard.save (err, doc) ->
    if !err
      widget = _.last doc.widgets
      id = widget._id
      # Scope the CSS so that it applies to the contents of that particular widget
      widget.scopedCSS = scopeCSS widget.css, id
      json = JSON.parse widget.json
      json._id = id
      json.apiKey = user.apiKey
      widget.json = JSON.stringify json, null, 2
      dashboard.save (err, doc) ->
        if !err
          widget = dashboard.widgets.id(id)
          ss.api.publish.channel "user_#{user._id}", 'widgetCreated', dashboardId: dashboard._id, widget: widget
          cb status: 'success', widget: widget
        else
          cb status: 'failure', reason: err
    else
      cb status: 'failure', reason: err

# A man who moves a mountain, starts by moving small stones - Chinese Proverb
#
module.exports = 

  create: (data, user, cb) ->
    Dashboard.findOne {_id: data.dashboardId}, (err, dashboard) ->
      if !err and dashboard?              
        if data.widgetTemplateId?
          WidgetTemplate.findOne {_id: data.widgetTemplateId}, (err, widgetTemplate) ->
            if !err and widgetTemplate?
              items = ['name', 'html', 'css', 'script', 'scriptType', 'json','width', 'height']
              for element in items
                data[element] = widgetTemplate[element]
                if items.indexOf(element) is items.length-1
                  createAWidgetDry(dashboard,data, user, cb)
            else
              cb status: 'failure', reason: "Widget Template not found"
        else
          createAWidgetDry(dashboard, data, user, cb)
      else
        cb status: 'failure', reason: if !dashboard then "dashboard with id #{data.dashboardId} not found" else err

  update: (data, cb) ->
    Dashboard.findOne {_id: data.dashboardId}, (err, dashboard) ->
      if !err and dashboard?
        widget = dashboard.widgets.id(data._id)
        if widget?
          oldJSON = JSON.parse widget.json
          widget[key] = value for key,value of data
          widget.scopedCSS  = scopeCSS widget.css, widget._id
          try
            newJSON           = JSON.parse widget.json
            newJSON._id       = oldJSON._id
            newJSON.apiKey    = oldJSON.apiKey
            widget.json = JSON.stringify newJSON, null, 2
          catch error
            widget.json = JSON.stringify oldJSON, null, 2
          widget.updatedAt = Date.now()
          dashboard.save (err, doc) ->
            if !err
              widget = dashboard.widgets.id(data._id)
              ss.api.publish.channel "user_#{dashboard.userId}", 'widgetUpdated', dashboardId: dashboard._id, widget: widget
              cb status: 'success', widget: dashboard.widgets.id(data._id)
            else
              cb status: 'failure', reason: err
        else
          cb status: 'failure', reason: "Widget with id: #{data._id} not found"
      else
        cb status: 'failure', reason: "No dashboard found with id #{data.dashboardId}"

  delete: (data, cb) ->
    Dashboard.findOne {_id: data.dashboardId}, (err, dashboard) ->
      if !err and dashboard?
        widget = dashboard.widgets.id(data._id)
        if widget?
          widget.remove() 
          dashboard.save (err, doc) ->
            if !err
              ss.api.publish.channel "user_#{dashboard.userId}", 'widgetDeleted', dashboardId: dashboard._id, widgetId: data._id
              cb status: 'success', widgetId: data._id
            else
              cb status: 'failure', reason: err
        else
          cb status: 'failure', reason: "No widget found with id #{data._id}"
      else
        cb status: 'failure', reason: "No dashboard found with id #{data.dashboardId}" 
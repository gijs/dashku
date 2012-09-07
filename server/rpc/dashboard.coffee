#### Dashboard rpc module ####

exports.actions = (req, res, ss) ->

  req.use 'session'

  create: (data) ->
    fetchUserFromSession req, res, (user) ->
      dashboardController.create name: data.name, userId: user._id, (response) -> res response

  getAll: ->
    fetchUserFromSession req, res, (user) ->
      dashboardController.getAll userId: user._id, (response) -> res response

  externalGet: (id) ->
    dashboardController.get {_id: id}, (response) ->
      req.session.channel.subscribe "user_#{response.dashboard.userId}" if response.status is 'success'
      res response

  update: (conditions={}) ->
    fetchUserFromSession req, res, (user) ->
      dashboardController.update _.extend(conditions, {userId: user._id}), (response) -> res response

  delete: (id) ->
    fetchUserFromSession req, res, (user) ->
      dashboardController.delete id: id, userId: user._id, (response) -> res response

  # I'm not going to port this RPC method to the HTTP API for now, I don't think there's much need for that ATM.
  updateWidgetPositions: (data) ->
    fetchUserFromSession req, res, (user) ->
      Dashboard.findOne {_id: data._id}, (err, dashboard) ->
        if !err and dashboard?
          for widget in dashboard.widgets
            widget.position = data.positions[widget._id]
            if dashboard.widgets.indexOf(widget) is (dashboard.widgets.length-1)
              dashboard.save (err, doc) ->
                if !err
                  ss.publish.channel "user_#{user._id}", 'widgetPositionsUpdated', {_id: dashboard._id, positions: data.positions}
                  res status: 'success'
                else
                  res status: 'failure', reason: err
        else
          res status: 'failure', reason: err
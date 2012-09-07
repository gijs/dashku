#### The Dashboard controller ####

module.exports =
  
  create: (data, cb) ->
    dashboard = new Dashboard data
    dashboard.save (err,doc) -> 
      if !err
        ss.api.publish.channel "user_#{data.userId}", 'dashboardCreated', doc
        cb status: 'success', dashboard: doc
      else
        cb status: 'failure', reason: err

  getAll: (data, cb) ->
    Dashboard.find data, {}, {sort: {name: 1}}, (err, dashboards) ->
      if !err and dashboards?
        cb status: 'success', dashboards: dashboards
      else
        cb status: 'failure', reason: err

  get: (data, cb) ->
    Dashboard.findOne data, (err, dashboard) ->
      if !err and dashboard?
        cb status: 'success', dashboard: dashboard
      else
        cb status: 'failure', reason: if dashboard? then err else "Dashboard not found"

  update: (data, cb) ->
    Dashboard.findOne {_id: data._id, userId: data.userId}, (err, dashboard) ->
      if !err and dashboard?
        dashboard[key] = value for key,value of data
        dashboard.updatedAt = Date.now()
        dashboard.save (err, dashboard) ->
          if !err
            # NOTE - My opinion is that models is a natural place for PubSub events
            # like this one. I may change this in the future
            ss.api.publish.channel "user_#{data.userId}", 'dashboardUpdated', dashboard            
            cb status: 'success', dashboard: dashboard
          else
            cb status: 'failure', reason: err
      else
        cb status: 'failure', reason: if dashboard? then err else "Dashboard not found"

  delete: (data, cb) ->
    Dashboard.find {userId: data.userId}, (err, dashboards) ->
      if !err and dashboards.length > 1
        Dashboard.remove {_id: data.id, userId: data.userId}, (err) ->
          if !err
            ss.api.publish.channel "user_#{data.userId}", 'dashboardDeleted', data.id
            cb status: 'success', dashboardId: data.id
          else
            cb status: 'failure', reason: "Dashboard not found"
      else
        cb status: 'failure', reason: err || "You can't delete your last dashboard"
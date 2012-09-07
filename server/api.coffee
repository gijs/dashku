#### The Dashku REST API #### 

# Fetch the API Key from Redis
apiKeyRequest = (apiKey, res, successFunction) ->
  Redis.hget "apiKeys", apiKey, (err, userId) ->
    if !err and userId?
      successFunction userId
    else
      res.writeHead 401, {'Content-Type': 'application/json'}
      res.write JSON.stringify status: 'failure', reason: if userId? then err else "Couldn't find a user with that API key"
      res.end()

# A helper function that generates the JSON response
applyStatusCodesToResponse = (res, response, statusCode=200, responseObject) ->
  if response.status is 'success'
    res.writeHead statusCode, {'Content-Type': 'application/json'}
    res.write JSON.stringify responseObject || response
    res.end()
  else
    res.writeHead 400, {'Content-Type': 'application/json'}    
    res.write JSON.stringify response
    res.end()

module.exports = (router) ->

  router.post '/api/transmission', (req, res, next) ->
    apiKey = req.body.apiKey || req.query.apiKey 
    apiKeyRequest apiKey, res, (userId) ->
      ss.api.publish.channel "user_#{userId}", 'transmission', req.body
      res.writeHead 200, {'Content-Type': 'application/json'}
      res.write JSON.stringify status: "success"
      res.end()

  router.get "/api/dashboards", (req,res, next) ->
    apiKeyRequest req.query.apiKey, res, (userId) ->
      dashboardController.getAll {userId: userId}, (response) ->
        applyStatusCodesToResponse res, response, 200, response.dashboards

  router.get "/api/dashboards/:id", (req,res,next) ->
    apiKeyRequest req.query.apiKey, res, (userId) ->
      dashboardController.get {userId: userId, _id: req.params.id}, (response) ->
        applyStatusCodesToResponse res, response, 200, response.dashboard

  router.post "/api/dashboards", (req, res, next) ->
    apiKeyRequest req.query.apiKey, res, (userId) ->
      dashboardController.create {name: req.body.name, userId: userId}, (response) ->
        applyStatusCodesToResponse res, response, 202, response.dashboard

  router.put "/api/dashboards/:id", (req, res, next) ->
    apiKeyRequest req.query.apiKey, res, (userId) ->
      dashboard         = req.body
      dashboard._id     = req.params.id
      dashboard.userId  = userId
      dashboardController.update dashboard, (response) ->
        applyStatusCodesToResponse res, response, 201, response.dashboard

  router.delete "/api/dashboards/:id", (req, res, next) ->
    apiKeyRequest req.query.apiKey, res, (userId) ->
      dashboardController.delete {userId: userId, id: req.params.id}, (response) -> 
        applyStatusCodesToResponse res, response, 201, {dashboardId: response.dashboardId}

  router.post "/api/dashboards/:dashboardId/widgets", (req, res, next) ->
    apiKeyRequest req.query.apiKey, res, (userId) ->
      data = req.body
      data.dashboardId = req.params.dashboardId
      widgetController.create data, {_id: userId, apiKey: req.query.apiKey}, (response) ->
        applyStatusCodesToResponse res, response, 202, response.widget

  router.put "/api/dashboards/:dashboardId/widgets/:id", (req, res, next) ->
    apiKeyRequest req.query.apiKey, res, (userId) ->
      data = req.body
      data._id = req.params.id
      data.dashboardId = req.params.dashboardId
      widgetController.update data, (response) -> 
        applyStatusCodesToResponse res, response, 201, response.widget

  router.delete "/api/dashboards/:dashboardId/widgets/:id", (req, res, next) ->
    apiKeyRequest req.query.apiKey, res, (userId) ->
      widgetController.delete {dashboardId: req.params.dashboardId, _id: req.params.id}, (response) ->
        applyStatusCodesToResponse res, response, 201, {widgetId: response.widgetId}

  router.get "/api/dashboards/:dashboardId/widgets/:id/downloads/:format", (req, res, next) ->
    require("#{__dirname}/scriptDownloader.coffee")(req, res)
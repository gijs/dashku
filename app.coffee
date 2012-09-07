fs                = require 'fs'
http              = require 'http'
connect           = require 'connect'
connectRoute      = require 'connect-route'
global.ss         = require 'socketstream'
global.uuid       = require 'node-uuid'
global._          = require 'underscore'
global.config     = require "#{__dirname}/server/config.coffee"

require "#{__dirname}/server/db.coffee"
require "#{__dirname}/server/mailer.coffee"

# Controllers, a way of sharing common logic between RPC and REST APIs
global.dashboardController  = require "#{__dirname}/server/controllers/dashboard.coffee"
global.widgetController     = require "#{__dirname}/server/controllers/widget.coffee"

# Define a single-page client
ss.client.define 'main',
  view: 'app.jade'
  css:  ['libs', 'app.styl']
  code: ['libs', 'app']
  tmpl: '*'

api = require "#{__dirname}/server/api.coffee"

ss.http.middleware.prepend ss.http.connect.bodyParser()
ss.http.middleware.prepend ss.http.connect.query()
ss.http.middleware.prepend connectRoute api

# Serve this client on the root URL
ss.http.route '/', (req, res) -> res.serveClient 'main'

# Use redis for session store
ss.session.store.use 'redis', config[ss.env].redis

# Use redis for pubsub
ss.publish.transport.use 'redis', config[ss.env].redis

# Code Formatters
ss.client.formatters.add require 'ss-coffee'
ss.client.formatters.add require 'ss-jade'
ss.client.formatters.add require 'ss-stylus'

# Use server-side compiled Hogan (Mustache) templates. Others engines available
ss.client.templateEngine.use require 'ss-hogan'

# Minimize and pack assets if you type: SS_PACK=1 SS_ENV=production node app.js
ss.client.packAssets() if ss.env is 'production'

# Start SocketStream
server = http.Server ss.http.middleware
server.listen config[ss.env].port
ss.start server

# So that the process never dies
process.on 'uncaughtException', (err) -> console.error 'Exception caught: ', err
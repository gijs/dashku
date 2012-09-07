# npm modules
global.mongoose   = require 'mongoose'
global.redis      = require 'redis'

# Redis-related configuration
global.Redis = redis.createClient config[ss.env].redis.port, config[ss.env].redis.host
Redis.auth(config[ss.env].redis.pass) if ss.env is 'production'

# MongoDB-related configuration
mongoose.connect "mongodb://#{config[ss.env].db}"
global.Schema   = mongoose.Schema
global.ObjectId = Schema.ObjectId

require "#{__dirname}/models/user.coffee"
require "#{__dirname}/models/widget.coffee"
require "#{__dirname}/models/dashboard.coffee"
require "#{__dirname}/models/widgetTemplate.coffee"
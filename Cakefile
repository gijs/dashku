# Cakefile

loadDependencies = ->
  env                       = process.env["SS_ENV"] || "development"
  global.ss                 = require 'socketstream'
  global.uuid               = require 'node-uuid'
  global.config             = require "#{__dirname}/server/config"
  db                        = require "#{__dirname}/server/db"
  global.fs                 = require 'fs'

# If you move to a new Redis DB, you may want to run this function
# to regenerate the API Key database
regenerateApiKeyDb = ->
  loadDependencies()
  User.find {}, (err, docs) ->
    if !err
      for doc in docs
        console.log "we did this"
        Redis.hset "apiKeys", doc.apiKey, doc._id, redis.print

# This populates the WidgetTemplates collection with Widget Templates
populateWidgetTemplates = ->
  loadDependencies()
  console.log "Clearing the WidgetTemplates collection"
  WidgetTemplate.remove {}, (err) ->
    if !err
      fs.readdir "#{__dirname}/server/seed/widgetTemplates/", (err, files) ->
        if !err and files
          for file in files
            widgetTemplate = new WidgetTemplate require "#{__dirname}/server/seed/widgetTemplates/#{file}"
            widgetTemplate.save (err,doc) -> 
              if !err
                console.log "WidgetTemplate collection populated"
              else
                console.log "There was an error populating the WidgetTemplate collection"
    else
      console.log "There was an error clearing the WidgetTemplates collection"
      process.exit 1

files = [
  "server/models/user.coffee"
]

test = (callback) ->
  mocha                 = require 'mocha'
  process.env["SS_ENV"] = "test"
  app                   = require './app.coffee'
  Mocha = new mocha
  for file in files
    Mocha.addFile "test/#{file.replace('.coffee','_test.coffee')}"
  Mocha.run()
  callback() if callback?

task 'test', 'run unit tests for the project', ->
  test()

task 'regenerateApiKeyDb', 'Compiles the SocketStream assets, and copies them to a fixed path', ->
  regenerateApiKeyDb()

task 'populateWidgetTemplates', "Populates the database with widget templates", ->
  populateWidgetTemplates()


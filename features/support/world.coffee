selenium              = require 'selenium-launcher'
soda                  = require 'soda'
process.env["SS_ENV"] = "cucumber"
app                   = require '../../app.coffee'

World = (callback) ->
  
  selenium (err, selenium) =>

    @browser = soda.createClient
      host:     selenium.host
      port:     selenium.port
      url:      config[ss.env].apiHost
      browser:  "googlechrome"

    callback {@browser}
    process.on 'exit', -> selenium.kill()

exports.World = World

# *firefox
# *mock
# *firefoxproxy
# *pifirefox
# *chrome
# *iexploreproxy
# *iexplore
# *firefox3
# *safariproxy
# *googlechrome
# *konqueror
# *firefox2
# *safari
# *piiexplore
# *firefoxchrome
# *opera
# *webdriver
# *iehta
# *custom
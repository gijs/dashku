#### General RPC module ####

md = require 'marked'
fs = require 'fs'

exports.actions = (req, res, ss) ->  

  req.use 'session'

  # This fetches a markdown document from the documentation, and returns the rendered html
  getDocument: (id) ->
    fs.readFile "#{__dirname}/../docs/#{id}.md", 'utf8', (err, data) ->
      if !err
        if id.match("api/")?
          fetchUserFromSession req, res, (user) ->
            data = data.replace /API_KEY/g , user.apiKey
            data = data.replace /DASHKU_API_URL/g , config[ss.env].apiHost

            res content: md data
        else
          res content: md data
      else
        res content: "Error accessing document"
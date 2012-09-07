rubyScript = '### Instructions
\n#    gem install em-http-request
\n#    ruby dashku_WIDGETID.rb
\n#
\nrequire "rubygems"
\nrequire "json"
\nrequire "em-http-request"
\n
\ndata = JSON.parse(\'JSONDATA\')
\n
\nEventMachine.run {
\n  http = EventMachine::HttpRequest.new("URL").post :body => data
\n  http.callback {
\n    EventMachine.stop
\n  }
\n}
\n
\n# Note - you will notice that the API url is different to the main url.
\n# I\'ve been experiencing DNS/latency problems with making the API call through
\n# to the main sitem so I\'ve used this ip address instead. 
\n#
\n# Paul Jensen'

nodejsScript = '// Instructions
\n//    npm install request
\n//    node dashku_WIDGETID.js
\n//
\nvar request = require("request");
\n
\nvar data = JSONDATA;
\n
\nrequest.post({url: "URL", body: JSON.stringify(data), json: true});
\n
\n// Note - you will notice that the API url is different to the main url.
\n// I\'ve been experiencing DNS/latency problems with making the API call through
\n// to the main sitem so I\'ve used this ip address instead. 
\n//
\n// Paul Jensen'


coffeeScript = '# Instructions
\n#    npm install request
\n#    coffee dashku_WIDGETID.coffee
\n#
\nrequest = require "request"
\n
\ndata = JSONDATA;
\n
\nrequest.post url: "URL", body: JSON.stringify(data), json: true
\n
\n# Note - you will notice that the API url is different to the main url.
\n# I\'ve been experiencing DNS/latency problems with making the API call through
\n# to the main sitem so I\'ve used this ip address instead. 
\n#
\n# Paul Jensen'

phpScript = '<?
\n// Instructions
\n// 
\n// php dashku_WIDGETID.php
\n//
\n// This code is courtesy of 
\n// Dan Morgan
\n//
\n// http://www.danmorgan.net/programming/simple-php-json-rest-post-client/
\n// 
\nfunction restcall($url,$vars) {
\n $headers = array(
\n \'Accept: application/json\',
\n \'Content-Type: application/json\',
\n );
\n $data = $vars;
\n 
\n $handle = curl_init();
\n curl_setopt($handle, CURLOPT_URL, $url);
\n curl_setopt($handle, CURLOPT_HTTPHEADER, $headers);
\n curl_setopt($handle, CURLOPT_RETURNTRANSFER, true);
\n curl_setopt($handle, CURLOPT_SSL_VERIFYHOST, false);
\n curl_setopt($handle, CURLOPT_SSL_VERIFYPEER, false);
\n 
\n curl_setopt($handle, CURLOPT_POST, true);
\n curl_setopt($handle, CURLOPT_POSTFIELDS, $data);
\n 
\n $response = curl_exec($handle);
\n $code = curl_getinfo($handle, CURLINFO_HTTP_CODE);
\n return $response;
\n}
\n
\nrestcall("THEURL",\'JSONDATA\');
\n
\n// Note - you will notice that the API url is different to the main url.
\n// I\'ve been experiencing DNS/latency problems with making the API call through
\n// to the main sitem so I\'ve used this ip address instead. 
\n//
\n// Paul Jensen
\n?>'

pythonScript = '# Instructions
\n#
\n# easy_install requests
\n# python dashku_WIDGETID.py
\n#
\nimport requests
\n
\nrequests.post(\'URL\', JSONDATA)
\n
\n# Note - you will notice that the API url is different to the main url.
\n# I\'ve been experiencing DNS/latency problems with making the API call through
\n# to the main sitem so I\'ve used this ip address instead. 
\n#
\n# Paul Jensen'

module.exports = (req,res) ->
  parsedFormat = req.params.format.split '.'
  fileFormat   = parsedFormat[parsedFormat.length-1]
  switch fileFormat
    when "rb"
      Dashboard.findOne {_id: req.params.dashboardId}, (err, dashboard) ->
        if !err and dashboard?
          widget = dashboard.widgets.id(req.params.id)
          data = rubyScript.replace(/URL/,config[ss.env].apiUrl).replace(/JSONDATA/,widget.json).replace(/WIDGETID/,widget._id)
          res.writeHead 200, { 'Content-disposition': 'attachment', 'Content-Type': 'application/ruby' }
          res.end data
        else
          res.writeHead 402, { 'Content-Type': 'text/plain' }
          res.end err
    when "js"
      Dashboard.findOne {_id: req.params.dashboardId}, (err, dashboard) ->
        if !err and dashboard?
          widget = dashboard.widgets.id(req.params.id)
          data = nodejsScript.replace(/URL/,config[ss.env].apiUrl).replace(/JSONDATA/,widget.json).replace(/WIDGETID/,widget._id)
          res.writeHead 200, {'Content-disposition': 'attachment', 'Content-Type': 'application/javascript' }
          res.end data
        else
          res.writeHead 402, { 'Content-Type': 'text/plain' }
          res.end err
    when "coffee"
      Dashboard.findOne {_id: req.params.dashboardId}, (err, dashboard) ->
        if !err and dashboard?
          widget = dashboard.widgets.id(req.params.id)
          data = coffeeScript.replace(/URL/,config[ss.env].apiUrl).replace(/JSONDATA/,widget.json).replace(/WIDGETID/,widget._id)
          res.writeHead 200, {'Content-disposition': 'attachment', 'Content-Type': 'application/coffeescript' }
          res.end data
        else
          res.writeHead 402, { 'Content-Type': 'text/plain' }
          res.end err
    when "php"
      Dashboard.findOne {_id: req.params.dashboardId}, (err, dashboard) ->
        if !err and dashboard?
          widget = dashboard.widgets.id(req.params.id)
          data = phpScript.replace(/THEURL/,config[ss.env].apiUrl).replace(/JSONDATA/,widget.json).replace(/WIDGETID/,widget._id)
          res.writeHead 200, {'Content-disposition': 'attachment', 'Content-Type': 'application/coffeescript' }
          res.end data
        else
          res.writeHead 402, { 'Content-Type': 'text/plain' }
          res.end err
    when "py"
      Dashboard.findOne {_id: req.params.dashboardId}, (err, dashboard) ->
        if !err and dashboard?
          widget = dashboard.widgets.id(req.params.id)
          data = pythonScript.replace(/URL/,config[ss.env].apiUrl).replace(/JSONDATA/,widget.json).replace(/WIDGETID/,widget._id)
          res.writeHead 200, {'Content-disposition': 'attachment', 'Content-Type': 'application/python' }
          res.end data
        else
          res.writeHead 402, { 'Content-Type': 'text/plain' }
          res.end err
    else
      res.writeHead 402, { 'Content-Type': 'text/plain' }
      res.end "not identified"
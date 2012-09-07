Create a widget
===

Creates a new widget

<span class="badge badge-post">POST</span> <span class="url">/api/dashboards/:dashboard_id/widgets</span>

Url Parameters
---

- dashboard_id: the id of the dashboard e.g. 4fd1f55b7e9b8705a1000054

Post Body
---

You will want to post a body with the following attributes:

- name: The name for your widget e.g. "New Account Sales"
- html: The html for your widget e.g.
    
      <div id="salesNumber"></div>


- css: The css for your widget e.g.

      #salesNumber {
        font-weight: bold;
        font-size: 24pt;
      }


- script: The script that is bound to your widget. e.g.

      var widget = this.widget;
      
      this.on('load', function(data){
        // Nothing to do
      });

      this.on('transmission', function(data){
        var salesNumber = widget.find('#salesNumber');
        salesNumber.text('$'+data.revenue).hide().fadeIn();
      });


- scriptType: The script type, can be either "javascript" or "coffeescript". Is "javascript" by default. 

- json: The example json that your widget uses when testing the widget out

      {
        "revenue": "346729.00"
      }


- width: The width of the widget, in pixels e.g. 200. Can be left unset to assume default value.
- height: The height of the widget, in pixels e.g .180. Can be left unset to assume default value.


You can try this out in your terminal with the rather lengthy command below (make sure to replace :dashboard_id with the id of a dashboard you have):

    curl -X POST -d "name=New%20Account%20Sales&html=%3Cdiv%20id%3D%22salesNumber%22%3E%3C%2Fdiv%3E&css=%23salesNumber%20%7B%0A%20%20font-weight%3A%20bold%3B%0A%20%20font-size%3A%2024pt%3B%0A%7D&script=var%20widget%20%3D%20this.widget%3B%0A%0Athis.on('load'%2C%20function(data)%7B%0A%20%20%2F%2F%20Nothing%20to%20do%0A%7D)%3B%0A%0Athis.on('transmission'%2C%20function(data)%7B%0A%20%20var%20salesNumber%20%3D%20widget.find('%23salesNumber')%3B%0A%20%20salesNumber.text('%24'%2Bdata.revenue).hide().fadeIn()%3B%0A%7D)%3B&json=%7B%0A%20%20%22revenue%22%3A%20%22346729.00%22%0A%7D" "DASHKU_API_URLapi/dashboards/:dashboard_id/widgets?apiKey=API_KEY"

Response
---

You should get back a JSON object which is the new widget:

    {
      "userId"      : "4fd1f55b7e9b8705a1000053",
      "_id"         : "4fd328d98caaf987a7000045",
      "updatedAt"   : "2012-06-09T10:43:37.292Z",
      "createdAt"   : "2012-06-09T10:43:37.292Z",
      "height"      : 180,
      "width"       : 200,
      "json"        : "{\n  \"revenue\": \"346729.00\",\n  \"_id\": \"4fd328d98caaf987a7000045\"\n}",
      "scriptType"  : "javascript",
      "script"      : "var widget = this.widget;\n\nthis.on('load', function(data){\n  // Nothing to do\n});\n\nthis.on('transmission', function(data){\n  var salesNumber = widget.find('#salesNumber');\n  salesNumber.text('$'+data.revenue).hide().fadeIn();\n});",
      "scopedCSS"   : ".widget[data-id='4fd328d98caaf987a7000045'] #salesNumber {\n  font-weight: bold;\n  font-size: 24pt;\n}",
      "css"         : "#salesNumber {\n  font-weight: bold;\n  font-size: 24pt;\n}",
      "html"        : "<div id=\"salesNumber\"></div>",
      "name"        : "New Account Sales"
    }

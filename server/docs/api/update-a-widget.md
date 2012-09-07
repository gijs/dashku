Update a widget
===

Updates an existing widget, given a dashboard id and widget id.

<span class="badge badge-put">PUT</span> <span class="url">/api/dashboards/:dashboard_id/widgets/:id</span>

Url Parameters
---

- dashboard_id: the id of the dashboard e.g. 4fd1f55b7e9b8705a1000054
- id: the id of the widget e.g. 4fd331e38caaf987a7000052

Put Body
---

You will want to post a body with the following optional attributes:

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

Let's say you ran the "create a widget example" on a dashboard, and found out that the sales number is too close to the top of the widget. We can update the css by adding a padding-top CSS rule to the existing css with this command:

    curl -X PUT -d "css=%23salesNumber%20%7B%0A%20%20font-weight%3A%20bold%3B%0A%20%20font-size%3A%2024pt%3B%0A%20%20padding-top%3A%2050px%3B%0A%7D" "DASHKU_API_URLapi/dashboards/:dashboard_id/widgets/:id?apiKey=API_KEY"

Response
---

You should expect back a JSON object that is the updated widget:

      {
        "_id"         : "4fd331e38caaf987a7000052",
        "userId"      : "4fd1f55b7e9b8705a1000053",
        "updatedAt"   : "2012-06-09T12:01:53.746Z",
        "createdAt"   : "2012-06-09T11:22:11.695Z",
        "height"      : 180,
        "width"       : 200,
        "json":"{\n  \"revenue\": \"346729.00\",\n  \"_id\": \"4fd331e38caaf987a7000052\"\n}",
        "scriptType"  : "javascript",
        "script"      : "var widget = this.widget;\n\nthis.on('load', function(data){\n  // Nothing to do\n});\n\nthis.on('transmission', function(data){\n  var salesNumber = widget.find('#salesNumber');\n  salesNumber.text('$'+data.revenue).hide().fadeIn();\n});",
        "scopedCSS"   : ".widget[data-id='4fd331e38caaf987a7000052'] #salesNumber {\n  font-weight: bold;\n  font-size: 24pt;\n  padding-top: 50px;\n}",
        "css"         : "#salesNumber {\n  font-weight: bold;\n  font-size: 24pt;\n  padding-top: 50px;\n}",
        "html"        : "<div id=\"salesNumber\"></div>",
        "name"        : "New Account Sales"
      }

module.exports = 
  name: "Peity Chart"
  html: ""
  css: "/* your widget's CSS goes here */\ncanvas {\n  margin-top: 12%;\n}\n"
  script: "// The widget's html as a jQuery object\nvar widget = this.widget;\n\n// This runs when the widget is loaded\nthis.on('load', function(data){\n  head.js('/javascripts/peity.min.js');\n});\n// This runs when the widget receives a transmission\nthis.on('transmission', function(data){\n  head.ready(function(){\n    widget.html(\n      \"<span class='pie' data-diameter='80'>\"\n      +data.amount+\"/\"+data.total+\"</span>\"\n    );\n    widget.find(\"span.pie\").peity(\"pie\", {\n      colours: [data.colours.total,data.colours.amount],\n      diameter: widget.height()/1.7\n    });\n  });\n\n});\n"
  json: "{\n  \"amount\": 3,\n  \"total\": 10,\n  \"colours\": {\n    \"amount\": \"#51FF00\",\n    \"total\": \"rgba(255,255,255,0.05)\"\n  }\n}"
  snapshotUrl: "/images/widgetTemplates/peityChart.png"

module.exports =
  name: "Peity Bar"
  html: "<span class=\"bar\">5,3,9,6,5,9,7,3,5,2</span>"
  css: "/* your widget's CSS goes here */\ncanvas {\n  margin-top: 10%;\n}"
  script: "// The widget's html as a jQuery object\nvar widget = this.widget;\n\n// This runs when the widget is loaded\nthis.on('load', function(data){\n  head.js('/javascripts/peity.min.js');\n  head.ready(function(){\n    widget.find(\".bar\").peity('bar',{\n      width: widget.width()*0.8,\n      height: widget.height()*0.6,\n      colour: 'yellow'\n    });\n  });\n\n});\n// This runs when the widget receives a transmission\nthis.on('transmission', function(data){\n  var bar = widget.find('.bar')\n  var existingData = bar.text().split(',')\n  if (existingData.length > 12) {existingData.shift()};\n  existingData.push(data.value);\n  bar.text(existingData.join(',')).change()\n});"
  json: '{\n  "value": 40\n}'
  snapshotUrl: "/images/widgetTemplates/peityBar.png"
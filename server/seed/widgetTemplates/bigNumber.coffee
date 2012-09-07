module.exports = 
  name: "Big Number"
  html: "<div id='bigNumber'></div>"
  css:  "#bigNumber {\n  padding: 10px;\n  margin-top: 50px;\n  font-size: 36pt;\n  font-weight: bold;\n}"
  script: "// The widget's html as a jQuery object\nvar widget = this.widget;\n\n// This runs when the widget is loaded\nthis.on('load', function(data){\n  console.log('loaded');
  \n});\n// This runs when the widget receives a transmission\nthis.on('transmission', function(data){\n  widget.find('#bigNumber').text(data.bigNumber);\n});"
  json: "{\n  \"bigNumber\":500\n}"
  snapshotUrl: "/images/widgetTemplates/bigNumber.png"

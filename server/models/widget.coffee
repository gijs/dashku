#### Widget Model ####

defaultHTML = "<!-- This is where your widget's html goes -->\n<img src='images/await.png'>"

defaultCSS = "/* your widget's CSS goes here */
\nimg {
\n  margin-top: 10px;
\n}
\n
\n#message {
\n  padding-top: 5px;
\n  color: #BD0000;
\n  font-size: 10pt;
\n}"

defaultScript = "// You can use 3rd-party libraries with your widget. For more information, 
\n// check out the Docs section titled 'Using 3rd-party JS libraries'.
\n
\n// The widget's html as a jQuery object
\nvar widget = this.widget;
\n
\n// This runs when the widget is loaded
\nthis.on('load', function(data){
\n  widget.append(\"<div id='message'>awaiting transmission</div>\").hide().fadeIn('slow');
\n});

\n// This runs when the widget receives a transmission
\nthis.on('transmission', function(data){
\n  var message = widget.find('#message');
\n  message.text(data.message).hide().fadeIn();
\n});"

defaultJSON = '{
\n  "message": "Affirmative, Dave. I read you."
\n}'

global.Widgets = new Schema
  name                : type: String, default: 'New Widget'
  html                : type: String, default: defaultHTML
  css                 : type: String, default: defaultCSS
  scopedCSS           : type: String, default: ''
  script              : type: String, default: defaultScript
  scriptType          : type: String, default: 'javascript'
  json                : type: String, default: defaultJSON
  userId              : type: ObjectId
  width               : type: Number, default: 200
  height              : type: Number, default: 180
  widgetTemplateId    : type: ObjectId
  position            : type: Number
  createdAt           : type: Date, default: Date.now
  updatedAt           : type: Date, default: Date.now
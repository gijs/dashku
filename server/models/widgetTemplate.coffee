#### WidgetTemplate model ####

WidgetTemplates = new Schema
  name                : type: String
  html                : type: String
  css                 : type: String
  script              : type: String
  scriptType          : type: String, default: 'javascript'
  json                : type: String
  snapshotUrl         : type: String
  width               : type: Number, default: 200
  height              : type: Number, default: 180
  createdAt           : type: Date, default: Date.now
  updatedAt           : type: Date, default: Date.now

global.WidgetTemplate = mongoose.model 'WidgetTemplate', WidgetTemplates
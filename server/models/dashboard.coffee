#### Dashboard Model ####

defaultCss = "/*\n\nYou can use custom CSS to style the dashboard as you like \n\nMake the changes that you like, then close the editor when you are happy.\n\nUncomment the block below to see the changes in real-time */\n\n/*\n\nbody {\n  background: #111;\n} \n\n*/"

Dashboards = new Schema
  name        : type: String
  createdAt   : type: Date, default: Date.now
  updatedAt   : type: Date, default: Date.now
  screenWidth : type: String, default: 'fixed'
  widgets     : [Widgets]
  userId      : type: ObjectId
  css         : type: String, default: defaultCss

global.Dashboard = mongoose.model 'Dashboard', Dashboards
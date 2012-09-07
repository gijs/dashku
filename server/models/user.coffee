#### User model ####

bcrypt     = require 'bcrypt'

toLower = (value) -> value.toLowerCase()

hashPassword = (password, cb) ->
  bcrypt.genSalt 10, (err, salt) -> 
    bcrypt.hash password, salt, (err, hash) -> 
      cb hash: hash, salt: salt

# NOTE - the password attribute exists in order
# to have a way to pass the value to the 
# encryption method. It is wiped clean by the 
# encryption method afterwards.
#
# This is a workaround for the moment, until I
# figure out a better way.
#
global.Users = new Schema
  username            : type: String, set: toLower
  email               : type: String, set: toLower
  password            : String                          
  passwordHash        : String
  passwordSalt        : String
  createdAt           : type: Date, default: Date.now
  updatedAt           : type: Date, default: Date.now
  apiKey              : type: String, default: uuid.v4
  changePasswordToken : String

# Clean the password attribute
Users.pre 'save', (next) ->
  if @isNew
    hashPassword @password, (hashedPassword) =>
      @passwordHash = hashedPassword.hash
      @passwordSalt = hashedPassword.salt
      @password     = undefined
      next()
  else
    next()

global.User = mongoose.model 'User', Users
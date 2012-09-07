#### Authentication RPC module ####

bcrypt     = require 'bcrypt'

forgottenPasswordEmailText = (link) -> "Hi,
\n
\nWe got a notification that you've forgotten your password. It's cool, we'll help you out. 
\n
\nIf you wish to change your password, follow this link: #{link}
\n
\nRegards,
\n
\n  Dashku Admin"

forgottenPasswordEmailHtml = (link) -> "<p>Hi,</p>
\n<p>We got a notification that you've forgotten your password. It's cool, we'll help you out.</p>
\n<p>If you wish to change your password, follow this link: <a>#{link}</a></p>
\n<p>Regards,</p>
\n<p>  Dashku Admin</p>"

# Hashes & Salts the password
hashPassword = (password, cb) ->
  bcrypt.genSalt 10, (err, salt) -> bcrypt.hash password, salt, (err, hash) -> cb hash: hash, salt: salt

exports.actions = (req, res, ss) ->

  req.use 'session'

  # Sign up a new user
  signup: (data) ->
      user = new User username: data.username, email: data.email, password: data.password
      user.save (err,doc) -> 
        if !err
          Redis.hset "apiKeys", doc.apiKey, doc._id, redis.print
          user = _id: doc._id, username: doc.username, email: doc.email
          req.session.userId = doc._id
          req.session.save (err) -> 
            if !err
              dashboard = new Dashboard name: "Your Dashboard", userId: user._id
              dashboard.save (err, doc) ->
                if !err
                  req.session.channel.subscribe "user_#{user._id}"
                  res status: 'success', user: user
                else
                  res status: 'failure', reason: "Failed to create dashboard for the new user"
            else
              res status: 'failure', reason: err
        else 
          res status: 'failure', reason: err

  # Check if a user is currently signed in, based on their session
  signedIn: ->
    fetchUserFromSession req, res, (user) ->
      req.session.channel.subscribe "user_#{user._id}"
      res status: 'success', user: _id: user._id, username: user.username, email: user.email, demoUser: user.demoUser

  # Login an existing user
  login: (data) ->
    query = if data.identifier.match('@')? then {email: data.identifier.toLowerCase()} else {username: data.identifier.toLowerCase()}
    User.findOne query, (err, doc) ->
      if doc?
        bcrypt.compare data.password, doc.passwordHash, (err, authenticated) ->
          if authenticated
              req.session.userId = doc._id
              req.session.save (err) ->
                if !err
                  req.session.channel.subscribe "user_#{doc._id}"
                  res status: 'success', user: _id: doc._id, username: doc.username, email: doc.email, demoUser: doc.demoUser
                else
                  res status: 'failure', reason: err
          else
            res status: 'failure', reason: "password incorrect"
      else
        res status: 'failure', reason: "the user #{data.identifier} does not exist"
  
  # Logout the user from the session
  logout: ->
    req.session.userId = null
    req.session.save (err) ->
      if !err 
        req.session.channel.reset()
        res status: 'success'
      else
        res status: 'failure', reason: err

  # Check if an attribute is unique, used by the signup form
  isAttributeUnique: (condition) ->
    User.findOne condition, (err, doc) -> res doc is null

  # Returns the account from the user session
  account: ->
    fetchUserFromSession req, res, (user) ->
      Redis.hget 'apiUsage', user.apiKey, (err, apiUsage) ->
        if !err
          res status: 'success', user: _id: user._id, username: user.username, email: user.email, apiUsage: apiUsage || 0, demoUser: user.demoUser
    
  # Generates an email and a forgotten password token, when the user has forgotten their password
  forgotPassword: (identifier) ->
    query = if identifier.match('@')? then {email: identifier.toLowerCase()} else {username: identifier.toLowerCase()}
    User.findOne query, (err, user) ->
      if !err and user?
        user.changePasswordToken = uuid.v4()
        user.save (err) ->
          if !err
            link = config[ss.env].forgottenPasswordUrl + user.changePasswordToken
            res status: 'success'
            mailOptions =
              from: "Dashku Admin <admin@dashku.com>"
              to: user.email
              subject: "Forgotten Password"
              text: forgottenPasswordEmailText link
              html: forgottenPasswordEmailHtml link 
            smtpTransport.sendMail mailOptions, (error, response) -> {}
          else
            res status: 'failure', reason: err

      else
        reason = if !err then "User not found with identifier: #{identifier}" else err
        res status: 'failure', reason: reason

  # Validates if the forgottenPasswordToken is valid
  loadChangePassword: (token) ->
    User.findOne {changePasswordToken: token}, (err, doc) ->
      if !err and doc?
        res status: 'success', token: doc.changePasswordToken
      else
        res status: 'failure', reason: err

  # Changes the user's password, as part of the forgotten password user flow
  changePassword: (data) ->
    User.findOne {changePasswordToken: data.token}, (err, user) ->
      if !err and user?
        hashPassword data.password, (hashedPassword) ->
          user.passwordHash = hashedPassword.hash
          user.passwordSalt = hashedPassword.salt
          user.changePasswordToken = uuid.v4()
          user.save (err) ->
            if !err
              res status: 'success'
            else
              res status: 'failure', reason: err
      else
        res status: 'failure', reason: err

  # Changes the user's password, from the account page
  changeAccountPassword: (data) ->
    fetchUserFromSession req, res, (user) ->
      bcrypt.compare data.currentPassword, user.passwordHash, (err, authenticated) ->
        if authenticated
          hashPassword data.newPassword, (hashedPassword) ->
            user.passwordHash = hashedPassword.hash
            user.passwordSalt = hashedPassword.salt
            user.save (err) ->
              if !err
                res status: 'success'
              else
                res status: 'failure', reason: err
        else
          res status: 'failure', reason: "Current password supplied was invalid"

  # Changes the user's email address, from the account page
  changeEmail: (data) ->
    fetchUserFromSession req, res, (user) ->
      User.find {email: data.email}, (err, users) ->
        if !err
          if users.length is 0
            user.email = data.email
            user.save (err) ->
              if !err
                res status: 'success'
              else
                res status: 'failure', reason: err
          else
            res status: 'failure', reason: "Someone already has that email address."
        else
          res status: 'failure', reason: err

  # Delete's the user's account, if they have supplied their password
  cancelAccount: (data) ->
    fetchUserFromSession req, res, (user) ->
      bcrypt.compare data.password, user.passwordHash, (err, authenticated) ->
        if authenticated
          req.session.userId = null
          req.session.save (err) ->
            if !err 
              req.session.channel.reset()
              Dashboard.remove {userId: user._id}, (err) ->
                if !err
                  User.remove {_id: user._id}, (err) ->
                    if !err
                      res status: 'success'
                    else
                      res status: 'failure', reason: err
                else
                  res status: 'failure', reason: err
            else
              res status: 'failure', reason: err
        else
          res status: 'failure', reason: "Password invalid"
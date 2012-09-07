#### HELPERS ####

# This fetches the user from the session
global.fetchUserFromSession = (req, res, next) ->
  User.findOne {_id: req.session.userId}, (err, user) ->
    if !err and user?
      next user
    else
      res status: 'failure', reason: err || "User not found"
assert  = require "assert"

describe "User", ->

  describe "new", ->

    it "should encrypt the password", (done) ->

      username  = "paulbjensen"
      email     = "paulbjensen@gmail.com"
      password  = "123456"
      user = new User {username, email, password}
      user.save (err, doc) ->
        assert.equal doc.password         , undefined
        assert.notEqual doc.passwordHash  , undefined
        assert.notEqual doc.passwordSalt  , undefined
        done()
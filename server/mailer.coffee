nodemailer = require 'nodemailer'


# TODO - move these configuration options into the config.coffee file
# Setup the global mail transport
global.smtpTransport = nodemailer.createTransport "SMTP",
  service: "Gmail"
  auth:
    user: "username"
    pass: "password"
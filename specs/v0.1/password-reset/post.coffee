
genEmail  = require('../shared/generators/email')
Promise   = require('es6-promise').Promise
request   = require('superagent')

# Attrs should include {email: "some-email@example.com"}
# If attrs is null, or undef, a default email will be filled in
# If attrs is an object (even empty), then that will be sent
requestPasswordReset = (attrs, agent = request) ->
  attrs ||= {email: genEmail()}
  new Promise((resolve, reject) ->
    agent
      .post("#{process.env.API_PATH}/password-reset")
      .send(attrs)
      .end (err, resp) ->
        if err?
          reject(err)
        else
          resolve(resp)
  )

module.exports = requestPasswordReset

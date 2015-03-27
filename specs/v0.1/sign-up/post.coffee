
gen     = require('../shared/generators')
Promise = require('es6-promise').Promise
request = require('superagent')

# Attrs should include {email: "some-email@example.com"}
# If attrs is null, or undef, a default email will be filled in
# If attrs is an object (even empty), then than will be sent
requestInvite = (attrs, agent = request) ->
  attrs ||= {email: gen.email()}
  new Promise((resolve, reject) ->
    agent
      .post("#{process.env.API_PATH}/sign-up")
      .send(attrs)
      .end (err, resp) ->
        if err?
          reject(err)
        else
          resolve(resp)
  )

module.exports = requestInvite

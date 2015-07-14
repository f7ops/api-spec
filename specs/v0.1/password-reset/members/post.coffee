
genEmail  = require('../../shared/generators/email')

Promise   = require('es6-promise').Promise
request   = require('superagent')
requestReset = require('../post')

getTokenForEmail = (email) ->
  new Promise((resolve, reject) ->
    requestReset({
      email: email
      url: "https://herp.derp.co/&&{token}"
    })
    .then (resp) ->
      token = resp["body"]["url"].split('&&')[1]
      resolve(token)
  )

# If no token is passed, the function will attempt to
# get one from the password-reset route.
resetPassword = (token, attrs, agent = request) ->
  email = attrs.email || genEmail()

  new Promise((resolve, reject) ->
    if token?
      resolve(token)
    else
      resolve(getTokenForEmail(email))
  )
  .then (token) ->
    return new Promise((resolve, reject) ->
      agent
        .post("#{process.env.API_PATH}/password-reset/#{token}")
        .send(attrs)
        .end (err, resp) ->
          if err?
            reject(err)
          else
            resolve(resp)
    )


module.exports = resetPassword

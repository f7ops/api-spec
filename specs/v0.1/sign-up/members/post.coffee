
gen     = require('../../shared/generators')
Promise = require('es6-promise').Promise
request = require('superagent')
requestInvite = require('../post')

getTokenForEmail = (email) ->
  new Promise((resolve, reject) ->
    requestInvite({
      email: email
      url: "http://herp.derp.co/&&{token}"
    })
    .then (resp) ->
      token = resp["body"]["url"].split('&&')[1]
      resolve(token)
  )

# If no token is passed, the function will attempt to
# get one from the sign-up route.
register = (token, attrs, agent = request) ->
  email = attrs.email || gen.email()

  new Promise((resolve, reject) ->
    if token?
      resolve(token)
    else
      resolve(getTokenForEmail(email))
  )
  .then (token) ->
    return new Promise((resolve, reject) ->
      agent
        .post("#{process.env.API_PATH}/sign-up/#{token}")
        .send(attrs)
        .end (err, resp) ->
          if err?
            reject(err)
          else
            resolve(resp)
    )


module.exports = register

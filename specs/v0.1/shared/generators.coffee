
uuid = require('node-uuid')
Promise = require('es6-promise').Promise
request = require('superagent')

email = () ->
  "#{uuid.v4()}@example.com"


# Create a new user with password (default: random)
# Returns a promise which resolves to the new user's email
user = (password) ->
  pw = password ||= Math.random().toString()
  addr = email()
  return new Promise((resolve, reject) ->
    request
      .post("#{process.env.API_PATH}/sign-up")
      .send({"email": addr, "url": "http://herp.derp.co/&&{token}"})
      .end (err, resp) ->
        token = resp["body"]["url"].split('&&')[1]
        request.post("#{process.env.API_PATH}/sign-up/#{token}")
          .send({"email": addr, "password": pw})
          .end((err, resp) ->
            resolve(addr)
          )
  )


putSession = require('../session/put')
signIn = (email, password, agent) ->
  putSession({email: email, password: password}, agent)

createAndSignInUser = (agent) ->
  throw "Agent required" unless agent?
  new Promise((resolve, reject) ->
    pw = Math.random().toString()
    user(pw)
      .then (email) -> signIn(email, pw, agent)
      .then -> resolve()
      .catch (err) -> reject(err)
  )



module.exports = {
  email: email,
  user: user
  createAndSignInUser: createAndSignInUser
}

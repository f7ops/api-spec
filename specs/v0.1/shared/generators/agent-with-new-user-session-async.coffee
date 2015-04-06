request = require('superagent')
Promise = require('es6-promise').Promise
user    = require('./user-async')

putSession = require('../../session/put')
signIn = (email, password, agent) ->
  putSession({email: email, password: password}, agent)

createAndSignInUser = () ->
  agent = request.agent()
  new Promise((resolve, reject) ->
    pw = Math.random().toString()
    user(pw)
      .then (email) -> signIn(email, pw, agent)
      .then -> resolve(agent)
      .catch (err) -> reject(err)
  )

module.exports = createAndSignInUser

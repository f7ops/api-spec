
Promise = require('es6-promise').Promise
request = require('superagent')

getMe = (attrs, agent = request) ->
  new Promise((resolve, reject) ->
    agent
      .get("#{process.env.API_PATH}/me")
      .end (err, resp) =>
        if err?
          reject(err)
        else
          resolve(resp)
  )

module.exports = getMe



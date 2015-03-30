

Promise = require('es6-promise').Promise
request = require('superagent')

signOut = (agent = request) ->
  new Promise((resolve, reject) ->
    agent
      .del("#{process.env.API_PATH}/session")
      .end (err, resp) ->
        if err?
          reject(err)
        else
          resolve(resp)
  )

module.exports = signOut

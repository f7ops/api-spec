
Promise = require('es6-promise').Promise
request = require('superagent')

signIn = (attrs, agent = request) ->
  new Promise((resolve, reject) ->
    agent
      .put("#{process.env.API_PATH}/session")
      .send(attrs)
      .end (err, resp) ->
        if err?
          console.log 'err'
          reject(err)
        else
          console.log 'resp'
          resolve(resp)
  )

module.exports = signIn

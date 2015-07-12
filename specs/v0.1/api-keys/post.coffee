Promise = require('es6-promise').Promise

createApiKey = (attrs, agent) ->
  throw "Agent required" unless agent?
  new Promise((resolve, reject) ->
    agent
      .post("#{process.env.API_PATH}/api-keys")
      .send(attrs)
      .end (err, resp) ->
        if err?
          reject(err)
        else
          resolve(resp)
  )

module.exports = createApiKey



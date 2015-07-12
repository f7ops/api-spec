Promise = require('es6-promise').Promise

getApiKeys = (agent) ->
  throw "Agent required" unless agent?
  new Promise((resolve, reject) ->
    agent
      .get("#{process.env.API_PATH}/api-keys")
      .end (err, resp) =>
        if err?
          reject(err)
        else
          resolve(resp)
  )

module.exports = getApiKeys



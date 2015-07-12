Promise = require('es6-promise').Promise

deleteApiKey = (id, agent) ->
  throw "Agent required" unless agent?
  new Promise((resolve, reject) ->
    agent
      .del("#{process.env.API_PATH}/api-keys/#{id}")
      .end (err, resp) =>
        if err?
          reject(err)
        else
          resolve(resp)
  )

module.exports = deleteApiKey


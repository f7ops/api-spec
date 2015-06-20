Promise = require('es6-promise').Promise

deleteToken = (id, agent) ->
  throw "Agent required" unless agent?
  new Promise((resolve, reject) ->
    agent
      .del("#{process.env.API_PATH}/tokens/#{id}")
      .end (err, resp) =>
        if err?
          reject(err)
        else
          resolve(resp)
  )

module.exports = deleteToken


Promise = require('es6-promise').Promise

getProjectContent = (id, agent) ->
  throw "Agent required" unless agent?
  new Promise((resolve, reject) ->
    agent
      .get("#{process.env.API_PATH}/projects/#{id}/content")
      .end (err, resp) =>
        if err?
          reject(err)
        else
          resolve(resp)
  )

module.exports = getProjectContent



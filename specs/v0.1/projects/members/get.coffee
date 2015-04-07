Promise = require('es6-promise').Promise

getProject = (id, agent) ->
  throw "Agent required" unless agent?
  new Promise((resolve, reject) ->
    agent
      .get("#{process.env.API_PATH}/projects/#{id}")
      .end (err, resp) =>
        if err?
          reject(err)
        else
          resolve(resp)
  )

module.exports = getProject

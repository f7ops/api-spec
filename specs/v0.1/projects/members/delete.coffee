Promise = require('es6-promise').Promise

deleteProject = (id, agent) ->
  throw "Agent required" unless agent?
  new Promise((resolve, reject) ->
    agent
      .del("#{process.env.API_PATH}/projects/#{id}")
      .end (err, resp) =>
        if err?
          reject(err)
        else
          resolve(resp)
  )

module.exports = deleteProject



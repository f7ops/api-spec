Promise = require('es6-promise').Promise

updateProject = (id, attrs, agent) ->
  throw "Agent required" unless agent?
  new Promise((resolve, reject) ->
    agent
      .put("#{process.env.API_PATH}/projects/#{id}")
      .send(attrs)
      .end (err, resp) =>
        if err?
          reject(err)
        else
          resolve(resp)
  )

module.exports = updateProject



Promise = require('es6-promise').Promise

updateProjectContent = (id, content, agent, headers = {}) ->
  throw "Agent required" unless agent?
  new Promise((resolve, reject) ->
    agent
      .put("#{process.env.API_PATH}/projects/#{id}/content")
      .set(headers)
      .send(content)
      .end (err, resp) =>
        if err?
          reject(err)
        else
          resolve(resp)
  )

module.exports = updateProjectContent



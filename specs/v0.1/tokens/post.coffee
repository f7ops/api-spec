Promise = require('es6-promise').Promise

createToken = (attrs, agent) ->
  throw "Agent required" unless agent?
  new Promise((resolve, reject) ->
    agent
      .post("#{process.env.API_PATH}/tokens")
      .send(attrs)
      .end (err, resp) ->
        if err?
          reject(err)
        else
          resolve(resp)
  )

module.exports = createToken



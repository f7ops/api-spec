

console.log "-- Sessions --"

request = require('superagent')
sharedErrors = require('./shared/errors')

describe "PUT /session", ->
  context "with missing params", ->
    query = (cb) ->
      agent = request.agent()
      agent
        .put("#{process.env.API_PATH}/session")
        .send({email: "x@example.com"})
        .end (err, resp) ->
          cb(err, resp)

    sharedErrors.missingParameters(query)

  context "with invalid credentials", ->
    xit "'invalid-credentials' error"
      # 400

  context "with valid params", ->
    xit "is successful"
      # 201

describe "DELETE /session", ->
  context "with existing session", ->

    xit "removes the cookie"
    xit "status 204"

  context "with no session", ->
    xit "returns 201"

describe "GET /me", ->
  context "with session", ->
    xit "returns user's email"
    xit "is successful"

  context "without session", ->
    xit "'unauthorized' error"


request = require('superagent')
expect = require('chai').expect

isMissingCredentials = require('../../shared/errors/is-missing-credentials')
genAgentWithNewUserSession = require('../../shared/generators/agent-with-new-user-session-async')
createToken = require('../post')

deleteToken = require('./delete')

describe "DELETE /tokens/:id", ->
  context "as anonymous", ->
    query = ->
      deleteToken("some-token", request.agent())

    isMissingCredentials(query)

  context "as user", ->
    before (done) ->
      @timeout(50000)
      genAgentWithNewUserSession()
        .then (agent) => @agent = agent
        .then => createToken({"label": ""}, @agent)
        .then (resp) => @token = resp["body"]
        .then -> done()
        .catch done

    context ":id does not exist", ->
      before (done) ->
        deleteToken("some-nonexistent-id", @agent)
          .then (resp) => @resp = resp
          .then -> done()
          .catch done

      it "status 204", ->
        expect(@resp["status"]).to.eq(204)

    context ":id belongs to user", ->
      before (done) ->
        deleteToken(@token["id"], @agent)
          .then (resp) => @resp = resp
          .then -> done()
          .catch done

      it "status 204", ->
        expect(@resp["status"]).to.eq(204)

      it "disables that key", (done) ->
        request
          .get("#{process.env.API_PATH}/me?token=#{@token["token"]}")
          .end (err, resp) ->
            expect(resp["status"]).to.eq(401)
            done(err)

    context ":id belongs to other", ->
      before (done) ->
        genAgentWithNewUserSession()
          .then (otherAgent) => createToken({}, otherAgent)
          .then (otherTokenResp) =>
            deleteToken(otherTokenResp["body"]["id"], @agent)
          .then (resp) => @resp = resp
          .then -> done()
          .catch done

      it "status 204", ->
        expect(@resp["status"]).to.eq(204)

      it "does not delete other user's key", (done) ->
        request
          .get("#{process.env.API_PATH}/me?key=#{@token["token"]}")
          .end (err, resp) ->
            expect(resp["status"]).to.eq(200)
            done(err)


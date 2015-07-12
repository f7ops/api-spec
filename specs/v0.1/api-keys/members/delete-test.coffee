
request = require('superagent')
expect = require('chai').expect

isMissingCredentials = require('../../shared/errors/is-missing-credentials')
genAgentWithNewUserSession = require('../../shared/generators/agent-with-new-user-session-async')
createKey = require('../post')

deleteKey = require('./delete')

describe "DELETE /api-keys/:id", ->
  context "as anonymous", ->
    query = ->
      deleteKey("some-key", request.agent())

    isMissingCredentials(query)

  context "as user", ->
    before (done) ->
      @timeout(50000)
      genAgentWithNewUserSession()
        .then (agent) => @agent = agent
        .then => createKey({"label": ""}, @agent)
        .then (resp) => @key = resp["body"]
        .then -> done()
        .catch done

    context ":id does not exist", ->
      before (done) ->
        deleteKey("0860dd0c-28b2-11e5-b933-6c3be57bb446", @agent)
          .then (resp) => @resp = resp
          .then -> done()
          .catch done

      it "status 204", ->
        expect(@resp["status"]).to.eq(204)

    context ":id belongs to user", ->
      before (done) ->
        deleteKey(@key["id"], @agent)
          .then (resp) => @resp = resp
          .then -> done()
          .catch done

      it "status 204", ->
        expect(@resp["status"]).to.eq(204)

      it "disables that key", (done) ->
        request
          .get("#{process.env.API_PATH}/me")
          .set("x-api-key", @key["key"])
          .end (err, resp) ->
            expect(resp["status"]).to.eq(401)
            done(err)

    context ":id belongs to other", ->
      before (done) ->
        genAgentWithNewUserSession()
          .then (otherAgent) => createKey({}, otherAgent)
          .then (otherKeyResp) =>
            @otherKey = otherKeyResp["body"]["key"]
            deleteKey(otherKeyResp["body"]["id"], @agent)
          .then (resp) => @resp = resp
          .then -> done()
          .catch done

      it "status 204", ->
        expect(@resp["status"]).to.eq(204)

      it "does not delete other user's key", (done) ->
        request
          .get("#{process.env.API_PATH}/me?key=#{@otherKey}")
          .end (err, resp) ->
            expect(resp["status"]).to.eq(200)
            done(err)


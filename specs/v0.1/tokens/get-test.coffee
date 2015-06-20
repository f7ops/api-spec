
_ = require('lodash')
request = require('superagent')
expect = require('chai').expect
isMissingCredentials = require('../shared/errors/is-missing-credentials')
genAgentWithNewUserSession = require('../shared/generators/agent-with-new-user-session-async')

createToken = require('./post')
getTokens = require('./get')

describe "GET /tokens", ->

  context "as anonymous", ->
    query = ->
      getTokens(request.agent())

    isMissingCredentials(query)

  context "as user", ->
    before (done) ->
      @timeout(100000)
      genAgentWithNewUserSession()
        .then (agent) => @agent = agent
        .then => createToken({}, @agent)
        .then => createToken({}, @agent)
        .then => createToken({}, @agent)
        .then => getTokens(@agent)
        .then (resp) => @resp = resp
        .then -> done()
        .catch done

    it "status 200", ->
      expect(@resp["status"]).to.eq(200)

    it "is application/json", ->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "is an Array", ->
      expect(@resp["body"]).to.be.an.instanceOf(Array)

    describe "each array member", ->
      before ->
        @each = _.partial(_.each, @resp["body"])

      it "does not have ['hash']", ->
        @each (token) -> expect(token["hash"]).to.be.undefined

      it "has ['id']", ->
        @each (token) -> expect(token["id"]).to.be.a('string')

      it "has ['label']", ->
        @each (token) -> expect(token["label"]).to.be.a('string')

      it "has ['created_at']", ->
        @each (token) -> expect(token["created_at"]).to.be.a('string')

    it "includes user's tokens", ->
      expect(@resp['body']).to.have.length(3)

    it "does not include other user's tokens", (done) ->
      genAgentWithNewUserSession() # create other user
        .then (agent) => createToken({}, agent) # for other user
        .then => getTokens(@agent)
        .then (resp) => expect(resp['body']).to.have.length(3) # should still have 3
        .then -> done()
        .catch done


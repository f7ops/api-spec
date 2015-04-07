
genAgentWithNewUserSession = require('../shared/generators/agent-with-new-user-session-async')
isMissingCredentials = require('../shared/errors/is-missing-credentials')

request = require('superagent')

getMe = require('./get')
expect = require('chai').expect

describe "GET /me", ->

  context "as anonymouts", ->
    query = ->
      getMe(request.agent())

    isMissingCredentials(query)

  context "as user", ->
    before (done) ->
      genAgentWithNewUserSession()
        .then (agent) => @agent = agent
        .then => getMe(@agent)
        .then (resp) => @resp = resp
        .then -> done()
        .catch done

    it "status 200", ->
      expect(@resp["status"]).to.eq(200)

    it "is application/json", ->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "has ['id']", ->
      expect(@resp["body"]['id']).to.be.a('string')

    it "has ['email']", ->
      expect(@resp["body"]['email']).to.be.a('string')

    it "has ['created_at']", ->
      expect(@resp["body"]['created_at']).to.be.a('string')

    it "has ['updated_at']", ->
      expect(@resp["body"]['updated_at']).to.be.a('string')

    it "does not have ['password']", ->
      expect(@resp["body"]['password']).not.to.be.defined


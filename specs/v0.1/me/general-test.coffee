genAgentWithNewUserSession = require('../shared/generators/agent-with-new-user-session-async')

request = require('superagent')

getMe = require('./get')
expect = require('chai').expect

describe "General API", ->

  context "as user", ->
    before (done) ->
      genAgentWithNewUserSession()
        .then (agent) => @agent = agent
        .then -> done()
        .catch done

    it "allows cross-origin requests from specific domains", (done) ->
      @agent
        .get("#{process.env.API_PATH}/me")
        .set('origin', "#{process.env.VALID_CORS_DOMAIN}")
        .end (err, resp) ->
          expect(resp.status).to.be.eq(200)
          done()

    it "rejects cross-origin requests from specific domains", (done) ->
      @agent
        .get("#{process.env.API_PATH}/me")
        .set('origin', "http://www.google.com")
        .end (err, resp) ->
          expect(resp.status).to.be.eq(404)
          done()


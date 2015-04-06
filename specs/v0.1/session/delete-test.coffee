
request = require('superagent')
expect = require('chai').expect

createAgentForNewUser = require('../shared/generators/agent-with-new-user-session-async')

signIn = require('./put')
signOut = require('./delete')
getMe = require('../me/get')

describe "DELETE /session", ->

  context "with existing session", ->

    before (done) ->
      createAgentForNewUser()
        .then (agent) =>
          @agent = agent
          signOut(@agent)
        .then (resp) => @resp = resp
        .then -> done()
        .catch(done)

    it "status 204",->
      expect(@resp["status"]).to.eq(204)

    it "removes the cookie",->
      expect(@resp["header"]["set-cookie"][0]).to.match(/^creds=;.*Expires=(.+);HttpOnly$/)
      # Assert expiration is in the past
      expires = /^creds=;.*Expires=([^;]+);.*HttpOnly$/.exec(@resp["header"]["set-cookie"][0])[1]
      expect(new Date(expires)).to.be.lt(new Date())

    context "when checking /me", ->
      it "errors", (done) ->
        getMe(@agent)
          .then (resp) -> expect(resp["status"]).to.eq(401)
          .then -> done()
          .catch done

  context "with no session", ->
    before (done) ->
      signOut(request.agent())
        .then (resp) => @resp = resp
        .then -> done()
        .catch done

    it "returns 204", ->
      expect(@resp["status"]).to.eq(204)




createAndSignInUser = require('../shared/generators').createAndSignInUser

request = require('superagent')

getMe = require('./get')
expect = require('chai').expect

describe "GET /me", ->

  context "with session", ->
    before (done) ->
      @agent = request.agent()
      createAndSignInUser(@agent)
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

  context "without session", ->
    before (done) ->
      getMe(request.agent())
        .then (resp) => @resp = resp
        .then -> done()
        .catch done

    it "status 401",->
      expect(@resp["status"]).to.eq(401)

    it "is application/json", ->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "has correct ['id']", ->
      expect(@resp["body"]["id"]).to.eq("missing-credentials")

    it "has correct ['url']", ->
      expect(@resp["body"]["url"]).to.eq("https://www.f7ops.com/docs/v0.1/#ce-missing-credentials")

    it "has correct ['message']", ->
      expect(@resp["body"]["message"]).to.match(/No credentials detected\./)


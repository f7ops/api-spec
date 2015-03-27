
getMe = require('./get')
expect = require('chai').expect

describe "GET /me", ->

  xcontext "with session", ->
    before (done) ->
      # get user from generator
      # sign in as user
      # get me and capture response

    it "status 200", ->
      expect(@resp["status"]).to.eq(200)

    it "is application/json", ->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    xit "has correct ['id']", ->
    xit "has correct ['email']", ->
    xit "has reasonable ['created_at']", ->
    xit "has reasonable ['updated_at']", ->

  context "without session", ->
    before (done) ->
      getMe({}).then((resp) => @resp = resp).then(-> done())

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


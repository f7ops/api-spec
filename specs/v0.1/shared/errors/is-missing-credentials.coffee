expect = require('chai').expect

module.exports = (query) ->
  describe "is a 'credentials-required' error", ->

    before (done) ->
      query()
        .then (resp) => @resp = resp
        .then -> done()
        .catch done

    it "status 401", ->
      expect(@resp["status"]).to.eq(401)

    it "is application/json",->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "has correct ['id']", ->
      expect(@resp["body"]["id"]).to.eq("credentials-required")

    it "has correct ['url']", ->
      expect(@resp["body"]["url"]).to.eq("https://www.f7ops.com/docs/v0.1/#ce-credentials-required")

    it "has correct ['message']", ->
      expect(@resp["body"]["message"]).to.match(/No credentials detected. Hows about an API token or valid session cookie/)


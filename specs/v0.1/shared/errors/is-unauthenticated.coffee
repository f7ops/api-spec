expect = require('chai').expect

module.export = (query) ->
  describe "is an 'unathenticated' error", ->

    before (done) ->
      query()
        .then (resp) => @resp = resp
        .then -> done()
        .catch done

    it "status 422",->
      expect(@resp["status"]).to.eq(401)

    it "is application/json",->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "has correct ['id']", ->
      expect(@resp["body"]["id"]).to.eq("unauthenticated")

    it "has correct ['url']", ->
      expect(@resp["body"]["url"]).to.eq("http://www.f7ops.com/docs/v0.1/#ce-unauthenticated")

    it "has correct ['message']", ->
      expect(@resp["body"]["message"]).to.match(/Unauthenticated/)

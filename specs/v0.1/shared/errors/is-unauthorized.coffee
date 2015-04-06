expect = require('chai').expect

module.export = (query) ->
  describe "is a 'unauthorized' error", ->

    before (done) ->
      query()
        .then (resp) => @resp = resp
        .then -> done()
        .catch done

    it "status 403",->
      expect(@resp["status"]).to.eq(403)

    it "is application/json",->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "has correct ['id']", ->
      expect(@resp["body"]["id"]).to.eq("unauthorized")

    it "has correct ['url']", ->
      expect(@resp["body"]["url"]).to.eq("http://www.f7ops.com/docs/v0.1/#ce-unauthorized")

    it "has correct ['message']", ->
      expect(@resp["body"]["message"]).to.match(/Unauthorized/)



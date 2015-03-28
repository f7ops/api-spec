
expect = require('chai').expect

# Missing Parameters ('missing-params')

exports.missingParameters = (query, expectedParams = []) ->
  describe "is a 'missing-params' error for #{expectedParams}", ->
    before (done) ->
      query((err, resp) =>
        @err = err
        @resp = resp
        done()
      )

    it "status 422",->
      expect(@resp["status"]).to.eq(422)

    it "is application/json",->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "has correct ['id']", ->
      expect(@resp["body"]["id"]).to.eq("missing-params")

    it "has correct ['url']", ->
      expect(@resp["body"]["url"]).to.eq("http://www.f7ops.com/docs/v0.1/#ce-missing-params")

    it "has correct ['params']", ->
      expect(@resp["body"]["params"]).to.eql(expectedParams)

    it "has correct ['message']", ->
      expect(@resp["body"]["message"]).to.match(/Missing one or more required parameters./)



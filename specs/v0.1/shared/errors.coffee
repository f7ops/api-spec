
expect = require('chai').expect

# Missing Parameters ('missing-params')

exports.missingParameters = (query, expectedParams = []) ->
  describe "is a 'missing-params' error", ->
    before (done) ->
      query((err, resp) =>
        @err = err
        @resp = resp
        done()
      )

    it "status 422",->
      expect(@resp["status"]).to.eq(422)

    it "is application/json",->
      expect(@resp["header"]["content-type"]).to.eq("application/json")

    it "has correct ['id']", ->
      expect(@resp["body"]["id"]).to.eq("missing-params")

    it "has correct ['url']", ->
      # TODO - find correct url
      expect(@resp["body"]["url"]).to.eq("")

    it "has correct ['params']", ->
      expect(@resp["body"]["params"]).to.eq(expectedParams)

    it "has correct ['message']", ->
      expect(@resp["body"]["message"]).to.eq("Some message")



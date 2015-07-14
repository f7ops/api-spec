
genEmail      = require('../shared/generators/email')

isMissingParams = require('../shared/errors/is-missing-params')

expect        = require('chai').expect
requestReset = require('./post')
genUser  = require('../shared/generators/user-async')

describe "POST /password-reset", ->
  context "with missing params", ->
    missingEmailQ = ->
      requestReset({})

    isMissingParams(missingEmailQ, ["url", "email"])

  # TODO -- test that only cors urls can be passed

  context "with valid params", ->
    before (done) ->
      @url = "http://herp.co/derp{token}={email}"
      genUser()
        .then (email) => requestReset({ "email": email, url: @url })
        .then (resp) => @resp = resp
        .then -> done()
        .catch done

    it "status 200",->
      expect(@resp["status"]).to.eq(200)

    it "is application/json",->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "has correct custom ['url']", ->
      expect(@resp["body"]["url"]).to.match(/^http:\/\/herp\.co\/derp.+=.+/)


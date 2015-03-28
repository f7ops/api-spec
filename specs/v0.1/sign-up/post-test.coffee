
gen           = require("../shared/generators")
expect        = require('chai').expect
requestInvite = require('./post')
sharedErrors  = require('../shared/errors')

describe "POST /sign-up", ->
  context "with missing params", ->
    missingEmailQ = (cb) ->
      requestInvite({}).then (resp) => cb(null, resp)

    sharedErrors.missingParameters(missingEmailQ, ["email"])

  context "with valid params", ->
    context "without custom url", ->
      before (done) ->
        requestInvite({ "email": gen.email() })
          .then (resp) => @resp = resp
          .then -> done()

      it "status 200",->
        expect(@resp["status"]).to.eq(200)

      it "is application/json",->
        expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

      it "has default ['url']", ->
        expect(@resp["body"]["url"]).to.match(/^https:\/\//)


    context "with custom url", ->
      before (done) ->
        @url = "http://herp.co/derp{token}={email}"
        requestInvite({ "email": gen.email(), url: @url })
          .then (resp) => @resp = resp
          .then -> done()

      it "status 200",->
        expect(@resp["status"]).to.eq(200)

      it "is application/json",->
        expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

      it "has correct custom ['url']", ->
        expect(@resp["body"]["url"]).to.match(/^http:\/\/herp\.co\/derp.+=.+/)


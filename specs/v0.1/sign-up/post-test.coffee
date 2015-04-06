
genEmail      = require('../shared/generators/email')

isMissingParams = require('../shared/errors/is-missing-params')

expect        = require('chai').expect
requestInvite = require('./post')

describe "POST /sign-up", ->
  context "with missing params", ->
    missingEmailQ = ->
      requestInvite({})

    isMissingParams(missingEmailQ, ["email"])

  context "with valid params", ->
    context "without custom url", ->
      before (done) ->
        requestInvite({ "email": genEmail() })
          .then (resp) => @resp = resp
          .then -> done()
          .catch done

      it "status 200",->
        expect(@resp["status"]).to.eq(200)

      it "is application/json",->
        expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

      it "has default ['url']", ->
        expect(@resp["body"]["url"]).to.match(/^https:\/\//)


    context "with custom url", ->
      before (done) ->
        @url = "http://herp.co/derp{token}={email}"
        requestInvite({ "email": genEmail(), url: @url })
          .then (resp) => @resp = resp
          .then -> done()
          .catch done

      it "status 200",->
        expect(@resp["status"]).to.eq(200)

      it "is application/json",->
        expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

      it "has correct custom ['url']", ->
        expect(@resp["body"]["url"]).to.match(/^http:\/\/herp\.co\/derp.+=.+/)


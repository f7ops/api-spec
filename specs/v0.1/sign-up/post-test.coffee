
Promise = require('es6-promise').Promise
request = require('superagent')
sharedErrors = require('../shared/errors')
expect = require('chai').expect

gen = require("../shared/generators")

describe "POST /sign-up", ->
  context "with missing params", ->
    missingEmailQ = (cb) ->
      request
        .post("#{process.env.API_PATH}/sign-up")
        .send({})
        .end (err, resp) ->
          cb(err, resp)

    sharedErrors.missingParameters(missingEmailQ, ["email"])

  context "with valid params", ->
    context "without custom url", ->
      before (done) ->
        request
          .post("#{process.env.API_PATH}/sign-up")
          .send({ "email": gen.email() })
          .end (err, resp) =>
            @resp = resp
            done()

      it "status 200",->
        expect(@resp["status"]).to.eq(200)

      it "is application/json",->
        expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

      it "has default ['url']", ->
        expect(@resp["body"]["url"]).to.match(/^http:\/\//)


    context "with custom url", ->
      before (done) ->
        @url = "http://herp.co/derp{token}={email}"
        request
          .post("#{process.env.API_PATH}/sign-up")
          .send({
            "email": "test@example.com"
            "url": @url
          })
          .end (err, resp) =>
            @resp = resp
            done()

      it "status 200",->
        expect(@resp["status"]).to.eq(200)

      it "is application/json",->
        expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

      it "has correct custom ['url']", ->
        expect(@resp["body"]["url"]).to.match(/^http:\/\/herp\.co\/derp.+=.+/)


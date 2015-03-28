
Promise = require('es6-promise').Promise
request = require('superagent')
sharedErrors = require('../shared/errors')
expect = require('chai').expect
gen = require('../shared/generators')

signIn = require('./put')

describe "PUT /session", ->
  context "with missing params", ->
    missingPasswordQ = (cb) ->
      signIn({email: gen.email()})
        .then((resp)-> cb(null, resp))
        .catch((err) -> cb(err, null))

    sharedErrors.missingParameters(missingPasswordQ, ["password"])

    missingEmailQ = (cb) ->
      signIn({password: "secret-password"})
        .then((resp)-> cb(null, resp))
        .catch((err) -> cb(err, null))

    sharedErrors.missingParameters(missingEmailQ, ["email"])

  context "with invalid credentials", ->
    before (done) ->
      signIn({email: "some@example.com", password: "secr3t"})
        .then((resp) =>
          @resp = resp
          done()
        )
        .catch(done)

    it "status 400",->
      expect(@resp["status"]).to.eq(400)

    it "is application/json",->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "has correct ['id']", ->
      expect(@resp["body"]["id"]).to.eq("invalid-credentials")

    it "has correct ['url']", ->
      expect(@resp["body"]["url"]).to.eq("https://www.f7ops.com/docs/v0.1/#invalid-credentials")

    it "has correct ['message']", ->
      expect(@resp["body"]["message"]).to.match(/No user with those credentials/)

  context "with valid params", ->
    before (done) ->
      password = "secret-password"
      @agent = request.agent()
      gen.user(password)
        .then((email) => signIn({email: email, password: password}, @agent))
        .then((resp) =>
          @resp = resp
          done()
        )
        .catch(done)

    it "status 204",->
      expect(@resp["status"]).to.eq(204)

    it "sets the session cookie",->
      expect(@resp["header"]["set-cookie"][0]).to.match(/^creds=.+;Expires=.+;HttpOnly$/)

    it "can be validated with /me", (done) ->
      @agent
        .get("#{process.env.API_PATH}/me")
        .end (err, resp) =>
          expect(resp["status"]).to.eq(200)
          done()



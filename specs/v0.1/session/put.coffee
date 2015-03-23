
Promise = require('es6-promise').Promise
request = require('superagent')
sharedErrors = require('../shared/errors')
expect = require('chai').expect

createUser = (email, password) ->
  new Promise((resolve, reject) ->
    request
      .post("#{process.env.API_PATH}/sign-up")
      .set("x-test-key", "i-am-testing")
      .send({email: email})
      .end (err, resp) ->
        request
          .post("#{process.env.API_PATH}/sign-up/#{resp.headers['x-test-token']}")
          .send({email: email, password: password})
          .end (err, resp) ->
            if err? then reject() else resolve()
  )


describe "PUT /session", ->
  context "with missing params", ->
    missingPasswordQ = (cb) ->
      request
        .put("#{process.env.API_PATH}/session")
        .send({email: "x@example.com"})
        .end (err, resp) ->
          cb(err, resp)

    sharedErrors.missingParameters(missingPasswordQ, ["password"])

    missingEmailQ = (cb) ->
      request
        .put("#{process.env.API_PATH}/session")
        .send({password: "some-password"})
        .end (err, resp) ->
          cb(err, resp)

    sharedErrors.missingParameters(missingEmailQ, ["email"])

  context "with invalid credentials", ->
    before (done) ->
      request
        .put("#{process.env.API_PATH}/session")
        .send({
          email: "x@example.com",
          password: "secret-password"
        })
        .end (err, resp) =>
          @err = err
          @resp = resp
          done()

    it "status 400",->
      expect(@resp["status"]).to.eq(400)

    it "is application/json",->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "has correct ['id']", ->
      expect(@resp["body"]["id"]).to.eq("invalid-credentials")

    it "has correct ['url']", ->
      expect(@resp["body"]["url"]).to.eq("http://www.hopper.com/docs/v0.1/#invalid-credentials")

    it "has correct ['message']", ->
      expect(@resp["body"]["message"]).to.match(/No user with those credentials/)

  context "with valid params", ->
    before (done) ->
      @email = "real@example.com"
      @password = "secret-password"
      createUser(@email, @password)
      .then =>
        request
          .put("#{process.env.API_PATH}/session")
          .send({
            email: @email,
            password: @password
          })
          .end (err, resp) =>
            @err = err
            @resp = resp
            done()

    it "status 204",->
      expect(@resp["status"]).to.eq(204)

    it "is application/json",->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "sets the session cookie",->
      expect(@resp["header"]["set-cookie"]).to.eq("")

    xit "can be validated with /me", ->
      # TODO




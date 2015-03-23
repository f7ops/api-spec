request = require('superagent')
sharedErrors = require('../../shared/errors')
expect = require('chai').expect
gen = require('../../shared/generators')

describe "POST /sign-up/<token>", ->
  context "with missing params", ->
    missingEmailQ = (cb) ->
      request
        .post("#{process.env.API_PATH}/sign-up/token")
        .send({
          "password": "secret-password"
        })
        .end (err, resp) ->
          cb(err, resp)

    sharedErrors.missingParameters(missingEmailQ, ["email"])

    missingPasswordQ = (cb) ->
      request
        .post("#{process.env.API_PATH}/sign-up/token")
        .send({
          "email": "me@example.com"
        })
        .end (err, resp) ->
          cb(err, resp)

    sharedErrors.missingParameters(missingPasswordQ, ["password"])

  context "with password too short", ->
    before (done) ->
      addr = gen.email()
      pw = "hi"
      request
        .post("#{process.env.API_PATH}/sign-up")
        .send({"email": addr, "url": "http://herp.derp.co/&&{token}"})
        .end (err, resp) =>
          token = resp["body"]["url"].split('&&')[1]
          request.post("#{process.env.API_PATH}/sign-up/#{token}")
            .send({"email": addr, "password": pw})
            .end((err, resp) =>
              @resp = resp
              done()
            )

    it "status 422",->
      expect(@resp["status"]).to.eq(422)

    it "is application/json",->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "has correct ['id']", ->
      expect(@resp["body"]["id"]).to.eq("password-too-short")

    it "has correct ['url']", ->
      expect(@resp["body"]["url"]).to.eq("http://www.hopper.com/admin/v0.1/#password-too-short")

    it "has correct ['message']", ->
      expect(@resp["body"]["message"]).to.match(/Password is too short\. Min\. 4/)

  context "with valid params", ->
    before (done) ->
      @email = gen.email()
      @password = "hiiiii"
      request
        .post("#{process.env.API_PATH}/sign-up")
        .send({"email": @email, "url": "http://herp.derp.co/&&{token}"})
        .end (err, resp) =>
          token = resp["body"]["url"].split('&&')[1]
          request.post("#{process.env.API_PATH}/sign-up/#{token}")
            .send({"email": @email, "password": @password})
            .end((err, resp) =>
              @resp = resp
              done()
            )

    it "status 204",->
      expect(@resp["status"]).to.eq(204)

    it "is application/json",->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "can authenticate the new user", (done) ->
      request
        .put("#{process.env.API_PATH}/session")
        .send({"email": @email, "password": @password})
        .end (err, resp) ->
          expect(resp["status"]).to.eq(204)

  context "with email taken", ->
    before (done) ->
      gen.user()
        .then (email) =>
          @password = "hiiiii"
          request
            .post("#{process.env.API_PATH}/sign-up")
            .send({"email": email, "url": "http://herp.derp.co/&&{token}"})
            .end (err, resp) =>
              token = resp["body"]["url"].split('&&')[1]
              request.post("#{process.env.API_PATH}/sign-up/#{token}")
                .send({"email": email, "password": @password})
                .end((err, resp) =>
                  @resp = resp
                  done()
                )

    it "status 400",->
      expect(@resp["status"]).to.eq(400)

    it "is application/json",->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "has correct ['id']", ->
      expect(@resp["body"]["id"]).to.eq("email-taken")

    it "has correct ['url']", ->
      expect(@resp["body"]["url"]).to.eq("http://www.hopper.com/admin/v0.1/#email-taken")

    it "has correct ['message']", ->
      expect(@resp["body"]["message"]).to.match(/This email is already registered./)

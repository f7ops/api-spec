request = require('superagent')
expect  = require('chai').expect

isMissingParams = require('../../shared/errors/is-missing-params')

signIn = require('../../session/put')
genEmail = require('../../shared/generators/email')
genUser  = require('../../shared/generators/user-async')

resetPassword = require('./post')

describe "POST /reset-password/<token>", ->
  context "with missing params", ->
    missingEmailQ = ->
      genUser()
        .then (email) ->
          resetPassword(null, {password: "secret-password"})

    isMissingParams(missingEmailQ, ["email"])

    missingPasswordQ = ->
      genUser()
        .then (email) ->
          resetPassword(null, {email: email})

    isMissingParams(missingPasswordQ, ["password"])

  context "with password too short", ->
    before (done) ->
      genUser()
        .then (email) ->
          resetPassword(null, {email: email, password: "hi"})
        .then((resp) => @resp = resp)
        .then(-> done())
        .catch(done)

    it "status 422",->
      expect(@resp["status"]).to.eq(422)

    it "is application/json",->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "has correct ['id']", ->
      expect(@resp["body"]["id"]).to.eq("password-too-short")

    it "has correct ['url']", ->
      expect(@resp["body"]["url"]).to.eq("https://www.f7ops.com/admin/v0.1/#password-too-short")

    it "has correct ['message']", ->
      expect(@resp["body"]["message"]).to.match(/Password is too short\. Min\. 4/)

  context "with valid params", ->
    before (done) ->
      genUser()
        .then (email) =>
          @password = "hiiiii"
          @email = email
          resetPassword(null, {email: @email, password: @password})
        .then (resp) => @resp = resp
        .then -> done()
        .catch done

    it "status 204",->
      expect(@resp["status"]).to.eq(204)

    it "can authenticate the new user", (done) ->
      signIn({email: @email, password: @password})
        .then((resp) -> expect(resp["status"]).to.eq(204))
        .then(-> done())
        .catch(done)

  context "with invalid token", ->
    before (done) ->
      genUser()
        .then (email) =>
          resetPassword("invalid-token", {email: email, password: "aoeu"})
        .then((resp) => @resp = resp)
        .then(=> done())
        .catch((err) -> done(err))

    it "status 400",->
      expect(@resp["status"]).to.eq(400)

    it "is application/json",->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "has correct ['id']", ->
      expect(@resp["body"]["id"]).to.eq("invalid-token")

    it "has correct ['url']", ->
      expect(@resp["body"]["url"]).to.eq("https://www.f7ops.com/admin/v0.1/#invalid-token")

    it "has correct ['message']", ->
      expect(@resp["body"]["message"]).to.match(/Token is not valid for email address./)

  context "with email not existent", ->
    before (done) ->
      @password = "hiiiii"
      resetPassword(null, {email: genEmail(), password: @password})
        .then((resp) => @resp = resp)
        .then(=> done())
        .catch((err) -> done(err))

    it "status 400",->
      expect(@resp["status"]).to.eq(422)

    it "is application/json",->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "has correct ['id']", ->
      expect(@resp["body"]["id"]).to.eq("email-not-found")

    it "has correct ['url']", ->
      expect(@resp["body"]["url"]).to.eq("https://www.f7ops.com/admin/v0.1/#email-not-found")

    it "has correct ['message']", ->
      expect(@resp["body"]["message"]).to.match(/A user with that email could not be found./)

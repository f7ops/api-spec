request = require('superagent')
expect  = require('chai').expect

isMissingParams = require('../../shared/errors/is-missing-params')

genEmail = require('../../shared/generators/email')
genUser  = require('../../shared/generators/user-async')

register = require('./post')
signIn   = require('../../session/put')

describe "POST /sign-up/<token>", ->
  context "with missing params", ->
    missingEmailQ = ->
      register(null, {password: "secret-password"})

    isMissingParams(missingEmailQ, ["email"])

    missingPasswordQ = ->
      register(null, {email: genEmail()})

    isMissingParams(missingPasswordQ, ["password"])

  context "with password too short", ->
    before (done) ->
      register(null, {email: genEmail(), password: "hi"})
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
      @email = genEmail()
      @password = "hiiiii"
      register(null, {email: @email, password: @password})
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
      register("invalid-token", {email: genEmail(), password: "aoeu"})
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

  context "with email taken", ->
    before (done) ->
      @password = "hiiiii"
      genUser()
        .then((email) => register(null, {email: email, password: @password}))
        .then((resp) => @resp = resp)
        .then(=> done())
        .catch((err) -> done(err))

    it "status 400",->
      expect(@resp["status"]).to.eq(400)

    it "is application/json",->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "has correct ['id']", ->
      expect(@resp["body"]["id"]).to.eq("email-taken")

    it "has correct ['url']", ->
      expect(@resp["body"]["url"]).to.eq("https://www.f7ops.com/admin/v0.1/#email-taken")

    it "has correct ['message']", ->
      expect(@resp["body"]["message"]).to.match(/This email is already registered./)

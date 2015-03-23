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

  context "with valid params", ->

  context "with email taken", ->

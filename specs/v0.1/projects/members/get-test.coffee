
request = require('superagent')

getProject = require('./get')

isMissingCredentials = require('../../shared/errors/is-missing-credentials')

describe "GET /projects/{id}", ->

  context "as anonymous", ->

    query = ->
      getProject("some-id", request.agent())

    isMissingCredentials(query)

  context "project does not exist", ->
    xit "404s"

  context "as non-owning user", ->

    xit "403s"

  context "as owning user", ->

    xit "returns 200"
    xit "is application/json"
    xit "with ['id']"
    xit "with ['user_id']"
    xit "with ['priority']"
    xit "with ['created_at']"
    xit "with ['updated_at']"


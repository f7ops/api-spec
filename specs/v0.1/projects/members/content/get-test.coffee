request = require('superagent')

isMissingCredentials = require('../../../shared/errors/is-missing-credentials')
getProjectContent = require('./get')

describe "GET /projects/{id}/content", ->

  context "as anonymous", ->
    query = ->
      getProjectContent("some-id", request.agent())

    isMissingCredentials(query)

  context "as non-owning user", ->
    xit "403s"

  context "as owning user", ->

    xit "can be retrieved as markdown"
    xit "can be retrieved as json"
    xit "defaults to json"

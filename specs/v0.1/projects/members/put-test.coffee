
request = require('superagent')

isMissingCredentials = require('../../shared/errors/is-missing-credentials')
updateProject = require('./put')

describe "PUT /projects/{id}", ->

  context "as anonymous", ->
    query = ->
      updateProject("some-id", {}, request.agent())

    isMissingCredentials(query)

  context "as non-owning user", ->

    xit "403s"

  context "as owning user", ->

    xit "allows the change of priority", ->
    xit "returns the updated entity"
    xit "disallows the change of content", ->


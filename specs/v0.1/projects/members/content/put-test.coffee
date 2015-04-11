
request = require('superagent')

isMissingCredentials = require('../../../shared/errors/is-missing-credentials')
updateProjectContent = require('./put')

describe "PUT /projects/{id}/content", ->

  context "as anonymous", ->
    query = ->
      updateProjectContent("some-id", "some content", request.agent())

    isMissingCredentials(query)

  context "project does not exist", ->
    xit "404s"

  context "as non-owning user", ->

    xit "403s"

  context "as owning user", ->

    context "with markdown", ->

      xit "updates the content of the project"
      xit "updates the modified date of the resource"
      xit "returns success 204"

    context "with json", ->

      xit "updates the content of the project"
      xit "updates the modified date of the resource"
      xit "returns success 204"

    context "with other", ->
      xit "422s"


request = require('superagent')

isMissingCredentials = require('../../shared/errors/is-missing-credentials')

deleteProject = require('./delete')

describe "DELETE /projects/{id}", ->

  context "as anonymous", ->

    query = ->
      deleteProject("some-id", request.agent())

    isMissingCredentials(query)

  context "as non-owning user", ->

    context "no project for that id exists", ->
      xit "204s"

    context "project with that id exists", ->
      xit "403s"

  context "as owning user", ->

    xit "204s"

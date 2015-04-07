request = require('superagent')

isMissingCredentials = require('../shared/errors/is-missing-credentials')
getProjects = require('./get')

describe "GET /projects", ->

  context "as anonymous", ->
    query = ->
      getProjects(request.agent())

    isMissingCredentials(query)

  context "as user", ->
    xit "returns a list of projects"
    xit "displays all the user's projects"
    xit "displays none of other user's projects"
    xit "includes contents"


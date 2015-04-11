# TODO - how to organize dependencies
#   - line up requires
#   - ordered into sections
#     - global libs
#     - ajaxes
#     - assertion helpers
#
_ = require('lodash')
Promise = require('es6-promise').Promise
request = require('superagent')

isMissingCredentials = require('../shared/errors/is-missing-credentials')
getProjects = require('./get')
genAgentWithNewUserSession = require('../shared/generators/agent-with-new-user-session-async')
expect = require('chai').expect
isValidProject = require('./is-valid-project')

createProject = require('./post')
getMe = require('../me/get')

describe "GET /projects", ->

  context "as anonymous", ->
    query = ->
      getProjects(request.agent())

    isMissingCredentials(query)

  context "as user", ->
    before (done) ->
      # TODO - notation for promises
      #   archibald uses getThing.ready() for generating them
      # TODO - convention for multi-request setus? do i like this?
      myProjects = genAgentWithNewUserSession()
        .then (agent) => @agent = agent
        .then => createProject({}, @agent)
        .then => createProject({}, @agent)
        .then => getMe(@agent)
        .then (me) => @me = me["body"]

      otherProjects = genAgentWithNewUserSession()
        .then (agent) => @otherUser = agent
        .then => createProject({}, @otherUser)

      Promise.all([myProjects, otherProjects])
        .then -> done()
        .catch done

    it "returns a list of the user's projects", (done) ->
      getProjects(@agent)
        .then (projects) =>
          expect(projects["body"]).to.have.length(2)
          _.each(projects["body"], (item) =>
            isValidProject(item)

            # Only this user's projects, none of others
            expect(item["user_id"]).to.eq(@me["id"])
          )
        .then -> done()
        .catch done


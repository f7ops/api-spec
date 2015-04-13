
request = require('superagent')

uuid = require('node-uuid').v4

expect = require('chai').expect
isMissingCredentials = require('../../shared/errors/is-missing-credentials')

deleteProject = require('./delete')
createProject = require('../post')
getProject    = require('./get')

Promise = require('es6-promise').Promise

genAgentWithNewUserSession = require('../../shared/generators/agent-with-new-user-session-async')

describe "DELETE /projects/{id}", ->

  context "as anonymous", ->

    query = ->
      deleteProject("some-id", request.agent())

    isMissingCredentials(query)

  context "as non-owning user", ->
    before (done) ->
      genMe = genAgentWithNewUserSession()
        .then (agent) => @agent = agent

      genOtherProject = genAgentWithNewUserSession()
        .then (agent) => @other = agent
        .then => createProject({}, @other)
        .then (resp) => @project = resp["body"]

      Promise.all([genMe, genOtherProject])
        .then -> done()
        .catch done

    context "no project for that id exists", ->
      it "204s", (done) ->
        deleteProject(uuid(), @agent)
          .then (resp) ->
            expect(resp["status"]).to.eq(204)
          .then -> done()
          .catch done

    context "project with that id exists", ->
      it "403s", (done) ->
        deleteProject(@project["id"], @agent)
          .then (resp) ->
            expect(resp["status"]).to.eq(403)
          .then -> done()
          .catch done

  context "as owning user", ->
    beforeEach (done) ->
      genMe = genAgentWithNewUserSession()
        .then (agent) => @agent = agent
        .then => createProject({}, @agent)
        .then (resp) => @project = resp["body"]
        .then -> done()
        .catch done

    it "204s", (done) ->
      deleteProject(@project["id"], @agent)
        .then (resp) ->
          expect(resp["status"]).to.eq(204)
        .then -> done()
        .catch done

    it "deletes the project", (done) ->
      deleteProject(@project["id"], @agent)
        .then => getProject(@project["id"], @agent)
        .then (resp) ->
          expect(resp["status"]).to.eq(404)
        .then -> done()
        .catch done

    it "still 204s after deleted", (done) ->
      deleteProject(@project["id"], @agent)
        .then (resp) ->
          expect(resp["status"]).to.eq(204)
        .then -> done()
        .catch done


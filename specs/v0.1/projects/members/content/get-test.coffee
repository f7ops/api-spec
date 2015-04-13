request = require('superagent')
uuid = require('node-uuid').v4

Promise = require('es6-promise').Promise

isMissingCredentials = require('../../../shared/errors/is-missing-credentials')
getProjectContent = require('./get')
createProject     = require('../../post')
genAgentWithNewUserSession = require('../../../shared/generators/agent-with-new-user-session-async')

expect = require('chai').expect

describe "GET /projects/{id}/content", ->

  context "as anonymous", ->
    query = ->
      getProjectContent("some-id", request.agent())

    isMissingCredentials(query)

  context "project does not exist", ->
    before (done) ->
      genMe = genAgentWithNewUserSession()
        .then (agent) => @agent = agent
        .then -> done()
        .catch done

    it "404s", (done) ->
      getProjectContent(uuid(), @agent)
        .then (resp) ->
          expect(resp["status"]).to.eq(404)
        .then -> done()
        .catch done

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

    it "403s", (done) ->
      getProjectContent(@project["id"], @agent)
        .then (resp) ->
          expect(resp["status"]).to.eq(403)
        .then -> done()
        .catch done


  context "as owning user", ->
    before (done) ->
      @contentJson = [{
        type: "project",
        name: "-- Missing Project Title --",
        contents: [],
        description: ""
      }]
      genAgentWithNewUserSession()
        .then (agent) => @agent = agent
        .then => createProject({content: @contentJson}, @agent)
        .then (resp) => @project = resp["body"]
        .then -> done()
        .catch done

    it "can be retrieved as markdown", (done) ->
      getProjectContent(@project["id"], @agent, {"Accept": "text/markdown"})
        .then (resp) ->
          expect(resp["status"]).to.eq(200)
          expect(resp["text"]).to.eq("# -- Missing Project Title --\n")
        .then -> done()
        .catch done

    it "can be retrieved as json", (done) ->
      getProjectContent(@project["id"], @agent, {"Accept": "application/json"})
        .then (resp) =>
          expect(resp["status"]).to.eq(200)
          expect(resp["body"]).to.deep.eq(@contentJson)
        .then -> done()
        .catch done

    it "defaults to json", (done) ->
      getProjectContent(@project["id"], @agent, {})
        .then (resp) =>
          expect(resp["status"]).to.eq(200)
          expect(resp["body"]).to.deep.eq(@contentJson)
        .then -> done()
        .catch done





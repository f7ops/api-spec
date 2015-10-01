
uuid = require('node-uuid').v4
request = require('superagent')

expect = require('chai').expect

isMissingCredentials = require('../../shared/errors/is-missing-credentials')
updateProject = require('./put')
createProject = require('../post')

Promise = require('es6-promise').Promise

isValidProject = require('../is-valid-project')
genAgentWithNewUserSession = require('../../shared/generators/agent-with-new-user-session-async')

# TODO - investigate content updating issue with malformed json
#   should not return 200 if incorrect
describe "PUT /projects/{id}", ->

  context "as anonymous", ->
    query = ->
      updateProject("some-id", {}, request.agent())

    isMissingCredentials(query)

  context "project does not exist", ->
    before (done) ->
      genAgentWithNewUserSession()
        .then (agent) => @agent = agent
        .then => updateProject(uuid(), {}, @agent)
        .then (resp) => @resp = resp
        .then -> done()
        .catch done

    it "404s", ->
      expect(@resp["status"]).to.eq(404)

  context "as non-owning user", ->
    before (done) ->
      @timeout(4000)
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
      updateProject(@project["id"], {priority: 4}, @agent)
        .then (resp) ->
          expect(resp["status"]).to.eq(403)
        .then -> done()
        .catch done

  context "as owning user", ->
    before (done) ->
      @originalContent = [
        {
            "type": "project",
            "description": "",
            "contents": [],
            "name": "Hello World"
        }
      ]
      @originalPriority = 45
      genAgentWithNewUserSession()
        .then (agent) => @agent = agent
        .then => createProject({
          priority: @originalPriority,
          content: @originalContent
        }, @agent)
        .then (resp) => @project = resp["body"]
        .then -> done()
        .catch done

    it "allows the change of priority", (done) ->
      @originalPriority = priority = Math.round(Math.random() * 100)
      updateProject(@project["id"], {priority: priority}, @agent)
        .then (resp) =>
          # Expect changed priority
          expect(resp["body"]["priority"]).to.eq(priority)

          # Expect updated timestamp
          oldUpdated = (new Date(@project["updated_at"])).valueOf()
          newUpdated = (new Date(resp["body"]["updated_at"])).valueOf()
          expect(oldUpdated).to.be.lt(newUpdated)

        .then -> done()
        .catch done

    it "allows the change of name", (done) ->
      name = "name1"
      updateProject(@project["id"], {name: name}, @agent)
        .then (resp) =>
          # Expect changed name
          expect(resp["body"]["name"]).to.eq(name)

          # Expect same content
          expect(resp["body"]["content"]).to.deep.eq(@originalContent)
          # Expect same priority
          expect(resp["body"]["priority"]).to.eq(@originalPriority)

          # Expect updated timestamp
          oldUpdated = (new Date(@project["updated_at"])).valueOf()
          newUpdated = (new Date(resp["body"]["updated_at"])).valueOf()
          expect(oldUpdated).to.be.lt(newUpdated)

        .then -> done()
        .catch done

    it "allows the change of content", (done) ->
      content = [{
        "type": "project",
        "description": "Hiiiii",
        "contents": [],
        "name": "Hellooooo"
      }]
      updateProject(@project["id"], {content: content}, @agent)
        .then (resp) =>
          # Expect changed content
          expect(resp["body"]["content"]).to.deep.eq(content)

          # Expect updated timestamp
          oldUpdated = (new Date(@project["updated_at"])).valueOf()
          newUpdated = (new Date(resp["body"]["updated_at"])).valueOf()
          expect(oldUpdated).to.be.lt(newUpdated)

        .then -> done()
        .catch done

    it "returns the updated entity", (done) ->
      content = []
      updateProject(@project["id"], {content: content}, @agent)
        .then (resp) =>
          isValidProject(resp["body"])
        .then -> done()
        .catch done




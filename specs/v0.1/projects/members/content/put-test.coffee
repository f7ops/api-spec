
expect = require('chai').expect
request = require('superagent')
Promise = require('es6-promise').Promise
uuid = require('node-uuid').v4

genAgentWithNewUserSession = require('../../../shared/generators/agent-with-new-user-session-async')

isMissingCredentials = require('../../../shared/errors/is-missing-credentials')
updateProjectContent = require('./put')
getProject           = require('../get')
createProject        = require('../../post')

describe "PUT /projects/{id}/content", ->

  context "as anonymous", ->
    query = ->
      updateProjectContent("some-id", "some content", request.agent())

    isMissingCredentials(query)

  context "project does not exist", ->
    before (done) ->
      genMe = genAgentWithNewUserSession()
        .then (agent) => @agent = agent
        .then -> done()
        .catch done

    it "404s", (done) ->
      updateProjectContent(uuid(), JSON.stringify([]), @agent)
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
      updateProjectContent(@project["id"], "# Hi", @agent, {"content-type": "text/markdown"})
        .then (resp) ->
          expect(resp["status"]).to.eq(403)
        .then -> done()
        .catch done

  context "as owning user", ->
    before (done) ->
      genAgentWithNewUserSession()
        .then (agent) => @agent = agent
        .then => createProject({}, @agent)
        .then (resp) => @project = resp["body"]
        .then -> done()
        .catch done

    context "with markdown", ->
      before ->
        @headers = {"content-type": "text/markdown"}

      it "updates the content of the project", (done) ->
        content = "# Hello World"
        updateProjectContent(@project["id"], content, @agent, {"content-type": "text/markdown"})
          .then => getProject(@project["id"], @agent)
          .then (resp) ->
            expect(resp["body"]["content"]).to.deep.eq([{
              "name": "Hello World",
              "contents": [],
              "description": "",
              "type": "project"
            }])
          .then -> done()
          .catch done

      it "updates the modified date of the resource", (done) ->
        content = "# Hello World"
        updateProjectContent(@project["id"], content, @agent, {"content-type": "text/markdown"})
          .then => getProject(@project["id"], @agent)
          .then (resp) =>
            previousUpdatedAt = new Date(@project["updated_at"]).valueOf()
            nowUpdatedAt = new Date(resp["body"]["updated_at"]).valueOf()
            expect(nowUpdatedAt).to.be.gt(previousUpdatedAt)
          .then -> done()
          .catch done

      it "returns success 200", (done) ->
        content = "# Hello World"
        updateProjectContent(@project["id"], content, @agent, {"content-type": "text/markdown"})
          .then (resp) ->
            expect(resp["status"]).to.eq(200)
          .then -> done()
          .catch done

    context "with json", ->
      before ->
        @headers = {"content-type": "application/json"}
        @content = [{
          "type": "project",
          "name": "Hello World",
          "description": "",
          "contents": []
        }]

      it "updates the content of the project", (done) ->
        updateProjectContent(@project["id"], JSON.stringify(@content), @agent, {"content-type": "application/json"})
          .then => getProject(@project["id"], @agent)
          .then (resp) =>
            expect(resp["body"]["content"]).to.deep.eq(@content)
          .then -> done()
          .catch done

      it "updates the modified date of the resource", (done) ->
        updateProjectContent(@project["id"], JSON.stringify(@content), @agent, {"content-type": "text/markdown"})
          .then => getProject(@project["id"], @agent)
          .then (resp) =>
            previousUpdatedAt = new Date(@project["updated_at"]).valueOf()
            nowUpdatedAt = new Date(resp["body"]["updated_at"]).valueOf()
            expect(nowUpdatedAt).to.be.gt(previousUpdatedAt)
          .then -> done()
          .catch done

      it "returns success 200", (done) ->
        updateProjectContent(@project["id"], JSON.stringify(@content), @agent, {"content-type": "text/markdown"})
          .then (resp) ->
            expect(resp["status"]).to.eq(200)
          .then -> done()
          .catch done

    context "with other", ->
      it "422s", (done) ->
        content = "<h1>Hello World</h1>"
        updateProjectContent(@project["id"], content, @agent, {"content-type": "text/html"})
          .then (resp) =>
            expect(resp["status"]).to.eq(422)
          .then -> done()
          .catch done

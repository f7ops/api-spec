
Promise = require('es6-promise').Promise
request = require('superagent')
uuid = require('node-uuid').v4
expect = require('chai').expect

getProject = require('./get')
createProject = require('../post')

isMissingCredentials = require('../../shared/errors/is-missing-credentials')
genAgentWithNewUserSession = require('../../shared/generators/agent-with-new-user-session-async')

describe "GET /projects/{id}", ->

  context "as anonymous", ->

    query = ->
      getProject("some-id", request.agent())

    isMissingCredentials(query)

  context "project does not exist", ->
    before (done) ->
      genAgentWithNewUserSession()
        .then (agent) => @agent = agent
        .then => getProject(uuid(), @agent) # non-existent project
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
      getProject(@project["id"], @agent)
        .then (resp) =>
          expect(resp["status"]).to.eq(403)
        .then -> done()
        .catch done


  context "as owning user", ->
    before (done) ->
      genAgentWithNewUserSession()
        .then (agent) => @agent = agent
        .then => createProject({}, @agent)
        .then (resp) => @project = resp["body"]
        .then => getProject(@project["id"], @agent)
        .then (resp) => @resp = resp
        .then -> done()
        .catch done

    it "returns 200", ->
      expect(@resp["status"]).to.eq(200)

    it "is application/json", ->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "with ['id']", ->
      expect(@resp["body"]['id']).to.be.a('string')

    it "with ['user_id']", ->
      expect(@resp["body"]['user_id']).to.be.a('string')

    it "with ['content']", ->
      expect(@resp["body"]['content']).to.be.an('array')

    it "with ['priority']", ->
      expect(@resp["body"]['priority']).to.be.a('number')

    it "with ['created_at']", ->
      expect(@resp["body"]['created_at']).to.be.a('string')

    it "with ['updated_at']", ->
      expect(@resp["body"]['updated_at']).to.be.a('string')

    it "with ['name']", ->
      expect(@resp["body"]['name']).to.be.a('string')


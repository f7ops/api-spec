
_ = require('lodash')
request = require('superagent')
expect = require('chai').expect

isMissingCredentials = require('../shared/errors/is-missing-credentials')
createProject = require('./post')

genAgentWithNewUserSession = require('../shared/generators/agent-with-new-user-session-async')

getMe = require('../me/get')

describe "POST /projects", ->

  context "as anonymous", ->
    query = ->
      createProject({}, request.agent())

    isMissingCredentials(query)


  context "as user", ->
    before (done) ->
      genAgentWithNewUserSession()
        .then (agent) => @agent = agent
        .then -> done()
        .catch done


    describe "has defaults", ->
      before (done) ->
        attrs = {}
        createProject(attrs, @agent)
          .then (resp) =>
            @resp = resp
          .then -> done()
          .catch done

      it "has status 201", ->
        expect(@resp["status"]).to.eq(201)

      it "is application/json", ->
        expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

      describe "the returned representation", ->

        it "has ['id']", ->
          expect(@resp["body"]['id']).to.be.a('string')

        it "has ['user_id']", (done) ->
          getMe(@agent)
            .then (me) =>
              expect(me["body"]["id"]).to.eq(@resp["body"]["user_id"])
            .then -> done()
            .catch done

        it "has ['content']", ->
          expect(_.isArray(@resp["body"]['content'])).to.be.true
          expect(@resp["body"]['content']).to.be.an('array')
          expect(@resp["body"]['content']).to.have.length(0) # assert default content []

        it "has ['priority']", ->
          expect(@resp["body"]['priority']).to.be.a('number')
          expect(@resp["body"]['priority']).to.be.eq(0) # assert default of 0

        it "has ['created_at']", ->
          expect(@resp["body"]['created_at']).to.be.a('string')

        it "has ['updated_at']", ->
          expect(@resp["body"]['updated_at']).to.be.a('string')

        it "has ['name']", ->
          expect(@resp["body"]['name']).to.be.a('string')
          expect(@resp["body"]['name']).to.be.eq("")

    describe "settable props", ->
      before (done) ->
        @priority = 24
        @name = "herp"
        attrs = {priority: @priority, name: @name}
        createProject(attrs, @agent)
          .then (resp) =>
            @resp = resp
          .then -> done()
          .catch done

      it "includes 'priority'", ->
        expect(@resp["body"]["priority"]).to.be.eq(@priority)

      it "includes 'name'", ->
        expect(@resp["body"]["name"]).to.be.eq(@name)

    describe "does not allow a user id to be set", ->
      before (done) ->
        otherUserAgent = null
        genAgentWithNewUserSession()
          .then (agent) => otherUserAgent = agent
          .then => getMe(otherUserAgent)
          .then (resp) => @otherUserId = resp["body"]["id"]
          .then => createProject({"user_id": @otherUserId}, @agent)
          .then (resp) => @resp = resp
          .then => getMe(@agent)
          .then (resp) => @me = resp["body"]
          .then -> done()
          .catch done

      it "belongs to the original user", ->
        # as opposed to the attempted other user
        expect(@resp["body"]["user_id"]).to.eq(@me["id"])

    it "permits posting of content as markdown", (done) ->
      attrs = {content: "# hello\n"}
      createProject(attrs, @agent)
        .then (resp) =>
          expect(_.isArray(resp["body"]["content"])).to.be.true
          expect(resp["body"]["content"]).not.to.eq([])
        .then -> done()
        .catch done


    it "permits posting of content as json", (done) ->
      attrs = {content: [{
        "name": "hii",
        "type": "project",
        "description": "Merp",
        "contents": []
      }]}
      createProject(attrs, @agent)
        .then (resp) =>
          expect(_.isArray(resp["body"]["content"])).to.be.true
          expect(resp["body"]["content"]).not.to.eq([])
        .then -> done()
        .catch done


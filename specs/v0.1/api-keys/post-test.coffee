
request = require('superagent')
expect = require('chai').expect
isMissingCredentials = require('../shared/errors/is-missing-credentials')
genAgentWithNewUserSession = require('../shared/generators/agent-with-new-user-session-async')

createKey = require('./post')
getMe = require('../me/get')

describe "POST /api-keys", ->

  context "as anonymous", ->
    query = ->
      createKey({}, request.agent())

    isMissingCredentials(query)

  context "as user", ->
    before (done) ->
      @label = "This is a label"
      genAgentWithNewUserSession()
        .then (agent) => @agent = agent
        .then => createKey({"label": @label}, @agent)
        .then (resp) => @resp = resp
        .then => getMe(@agent)
        .then (resp) => @me = resp["body"]
        .then -> done()
        .catch done

    it "status 201", ->
      expect(@resp["status"]).to.eq(201)

    it "is application/json", ->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "has ['label']", ->
      expect(@resp["body"]['label']).to.eq(@label)

    it "has ['id']", ->
      expect(@resp["body"]['id']).to.be.a('string')

    it "has ['created_at']", ->
      expect(@resp["body"]['created_at']).to.be.a('string')

    it "has ['key']", ->
      expect(@resp["body"]['key']).to.be.a('string')

    describe "can 'GET /me'", ->
      it "via header", (done) ->
        request
          .get("#{process.env.API_PATH}/me")
          .set("x-api-key", @resp["body"]["key"])
          .end (err, resp) =>
            expect(resp["body"]).to.deep.eql(@me)
            done(err)


      it "via url param", (done) ->
        request
          .get("#{process.env.API_PATH}/me?key=#{@resp["body"]["key"]}")
          .end (err, resp) =>
            expect(resp["body"]).to.deep.eql(@me)
            done(err)


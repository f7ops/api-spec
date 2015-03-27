
xdescribe "GET /me", ->

  context "with session", ->
    before (done) ->
      # get user from generator
      # sign in as user
      # get me and capture response

    it "status 200", ->
      expect(@resp["status"]).to.eq(200)

    it "is application/json", ->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    xit "has correct ['id']", ->
    xit "has correct ['email']", ->
    xit "has reasonable ['created_at']", ->
    xit "has reasonable ['updated_at']", ->

  context "without session", ->
    before (done) ->
      request
        .get("#{process.env.API_PATH}/me")
        .end (err, resp) =>
          @resp = resp
          done()

    it "status 401",->
      expect(@resp["status"]).to.eq(401)

    it "is application/json", ->
      expect(@resp["header"]["content-type"]).to.eq("application/json; charset=utf-8")

    it "has correct ['id']", ->
      expect(@resp["body"]["id"]).to.eq("unauthorized")

    it "has correct ['url']", ->
      expect(@resp["body"]["url"]).to.eq("http://www.hopper.com/admin/v0.1/#ca-unauthorized")

    it "has correct ['message']", ->
      expect(@resp["body"]["message"]).to.match(/No credentials detected\./)


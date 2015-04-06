
describe "GET /projects/{id}/content", ->

  context "as anonymous", ->

    xit "401s", ->

  context "as non-owning user", ->

    xit "403s"

  context "as owning user", ->

    xit "can be retrieved as markdown"
    xit "can be retrieved as json"
    xit "defaults to json"

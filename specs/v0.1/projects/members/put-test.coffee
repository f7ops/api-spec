
describe "PUT /projects/{id}", ->

  context "as anonymous", ->

    xit "401s", ->

  context "as non-owning user", ->

    xit "403s"

  context "as owning user", ->

    xit "allows the change of priority", ->
    xit "returns the updated entity"
    xit "disallows the change of content", ->


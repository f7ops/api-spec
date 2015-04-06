
describe "GET /projects/{id}", ->

  context "as anonymous", ->

    xit "401s", ->

  context "as non-owning user", ->

    xit "403s"

  context "as owning user", ->

    xit "returns 200"
    xit "is application/json"
    xit "with ['id']"
    xit "with ['user_id']"
    xit "with ['priority']"
    xit "with ['created_at']"
    xit "with ['updated_at']"

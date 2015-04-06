
describe "PUT /projects/{id}/content", ->

  context "as anonymous", ->

    xit "401s", ->

  context "as non-owning user", ->

    xit "403s"

  context "as owning user", ->

    context "with markdown", ->

      xit "updates the content of the project"
      xit "updates the modified date of the resource"
      xit "returns success 204"

    context "with json", ->

      xit "updates the content of the project"
      xit "updates the modified date of the resource"
      xit "returns success 204"



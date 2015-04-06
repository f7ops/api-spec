
describe "DELETE /projects/{id}", ->

  context "as anonymous", ->

    xit "401s", ->

  context "as non-owning user", ->

    context "no project for that id exists", ->
      xit "204s"

    context "project with that id exists", ->
      xit "403s"

  context "as owning user", ->

    xit "204s"


describe "POST /projects", ->

  context "when unauthenticated", ->

    xit "returns an unauthentiacted error"

  context "user logged in", ->

    xit "creates a new project for the user"
    xit "does not allow a user id to be set"
    xit "has default content"
    xit "has a default priority of 0"

    xit "permits posting of content as markdown"
    xit "permits posting of content as json"

    describe "the returned representation", ->

      xit "includes ['id']"
      xit "includes ['user_id']"
      xit "includes ['content']"
      xit "includes ['priority']"
      xit "includes ['created_at']"
      xit "includes ['updated_at']"

    xit "has status 'Created'"
    xit "has content type json"

    xit "Appears in the user's index"

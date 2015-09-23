
expect = require('chai').expect

isValidProject = (project) ->

  expect(project["id"]).to.be.a('string')
  expect(project["user_id"]).to.be.a('string')
  expect(project["content"]).to.be.an('array')
  expect(project["priority"]).to.be.an('number')
  expect(project["created_at"]).to.be.a('string')
  expect(project["updated_at"]).to.be.a('string')
  expect(project["name"]).to.be.a('string')

module.exports = isValidProject




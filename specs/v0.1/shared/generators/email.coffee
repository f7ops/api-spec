uuid = require('node-uuid')

email = ->
  "#{uuid.v4()}@example.com"

module.exports = email

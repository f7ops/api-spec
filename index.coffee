
require('dotenv').load()

console.log "API Path: #{process.env.API_PATH}"


# /session
require('./specs/v0.1/session/put')
require('./specs/v0.1/session/delete')

# /me
require('./specs/v0.1/me/get')


require('dotenv').load()

console.log "API Path: #{process.env.API_PATH}"

# /sign-up
require('./specs/v0.1/sign-up/post')
require('./specs/v0.1/sign-up/members/post')

# /session
require('./specs/v0.1/session/put')
require('./specs/v0.1/session/delete')

# /me
require('./specs/v0.1/me/get')

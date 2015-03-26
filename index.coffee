
# Taken from https://github.com/coolaj86/node-ssl-root-cas
#
# See section 'BAD IDEAS'
# This seems ok since this process doesn't really care whether or not tls
# certs are valid. Nobody is going to Mitm my testing suite..
#
## Start bad ideas
process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0"
## End bad ideas



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

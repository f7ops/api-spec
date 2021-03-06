
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

# api general
require('./specs/v0.1/me/general-test')

# /sign-up
require('./specs/v0.1/sign-up/post-test')
require('./specs/v0.1/sign-up/members/post-test')

# /password-reset
require('./specs/v0.1/password-reset/post-test')
require('./specs/v0.1/password-reset/members/post-test')

# /session
require('./specs/v0.1/session/put-test')
require('./specs/v0.1/session/delete-test')

# /me
require('./specs/v0.1/me/get-test')

# /projects
require('./specs/v0.1/projects/get-test')
require('./specs/v0.1/projects/post-test')

require('./specs/v0.1/projects/members/get-test')
require('./specs/v0.1/projects/members/put-test')
require('./specs/v0.1/projects/members/delete-test')

require('./specs/v0.1/projects/members/content/get-test')
require('./specs/v0.1/projects/members/content/put-test')

# /api-keys

require('./specs/v0.1/api-keys/post-test')
require('./specs/v0.1/api-keys/get-test')
require('./specs/v0.1/api-keys/members/delete-test')

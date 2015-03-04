
require('dotenv').load()

console.log "API Path: #{process.env.API_PATH}"

require('./specs/v0.1/session')


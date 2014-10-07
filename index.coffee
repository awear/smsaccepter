express = require 'express'
app = express()
PORT = process.env.PORT || 9999

app.use require('body-parser').raw()

app.post '/', (req, res) ->
  console.log "we got a post from somebody: '#{req.body.toString()}'"
  res.status(201).send {}

app.listen PORT
console.log "server listening on #{PORT}"

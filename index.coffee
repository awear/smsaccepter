PORT = process.env.PORT || 9999
MONGO_URL = process.env.MONGOHQ_URL || 'mongodb://localhost:27017/test'

{MongoClient} = require 'mongodb'
Q = require 'q'
express = require 'express'
_ = require 'underscore'
bodyparser = require 'body-parser'

app = express()
app.use bodyparser.raw()
app.use bodyparser.json()

Q.ninvoke(MongoClient, 'connect', MONGO_URL)
  .then (db) ->
    collection = db.collection 'messages'

    app.post '/user/:userid', (req, res) ->
      {userid} = req.params
      messages = _.map req.body, (message) ->
        _.extend {userid}, message
      Q.ninvoke(collection, 'insert', messages)
        .done (-> res.status(201).send {}),
          ((e) -> res.status(500).send {error: "ise"})

    app.delete '/user/:userid', (req, res) ->
      {userid} = req.params
      Q.ninvoke(collection, 'remove', {userid})
        .done (-> res.status(200).send {}),
          ((e) -> res.status(500).send {error: "ise"})
      
    app.listen PORT
    console.log "server listening on #{PORT}"

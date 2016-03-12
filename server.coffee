express = require 'express'
body_parser = require 'body-parser'
winston = require 'winston'
express_winston = require 'express-winston'
api = require './app/api'
fs = require 'fs'

PORT = '9998'

fs.readFile 'database.json', 'utf8', (err, data) ->
  if err? then throw err
  database_config = JSON.parse(data)

  server = express()
  server.use(body_parser.json())
  server.use(body_parser.urlencoded(extended: yes))
  router = express.Router()

  router.use(express_winston.logger(transports: [new winston.transports.Console(json: true)]))

  knex = require('knex')(
    client: 'pg'
    connection:
      host: database_config.postgres.host
      user: database_config.postgres.user
      password: database_config.postgres.password
      database: database_config.postgres.database
  )

  bookshelf = require('bookshelf')(knex)
  api.init(router, bookshelf)

  server.use('/api', router)

  server.listen(PORT)
  console.log "Started server on #{PORT}"
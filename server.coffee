express = require 'express'
body_parser = require 'body-parser'
winston = require 'winston'
express_winston = require 'express-winston'
api = require './app/api'

PORT = '9998'
PG_URL = 'localhost'
PG_USERNAME = 'postgres'
PG_PASSWORD = 'postgres'
PG_DATABASE = 'scheduler'

server = express()
server.use(body_parser.json())
server.use(body_parser.urlencoded(extended: yes))
router = express.Router()

router.all '*', (req, res, next) ->
  res.header("Access-Control-Allow-Origin", "*")
  res.header("Access-Control-Allow-Headers", "X-Requested-With")
  next()

router.use(express_winston.logger(transports: [new winston.transports.Console(json: true)]))

knex = require('knex')(
  client: 'pg'
  connection:
    host: PG_URL
    user: PG_USERNAME
    password: PG_PASSWORD
    database: PG_DATABASE)

bookshelf = require('bookshelf')(knex)
api.init(router, bookshelf)

server.use('/api', router)

server.listen(PORT)
console.log "Started server on #{PORT}"
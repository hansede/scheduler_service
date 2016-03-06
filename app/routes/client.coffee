module.exports = (bookshelf) ->

  Client = bookshelf.Model.extend(tableName: 'clients')

  get: (req, res) ->
    Client.forge().query(where: req.query).fetchAll()
      .then (collection) -> res.send(JSON.stringify(collection.models))
      .catch -> res.sendStatus(500)

  post: (req, res) ->
    Client.forge(req.body).save()
      .then (client) ->
        res.status(201)
        res.send("/api/client/#{client.get('id')}")
      .catch -> res.sendStatus(500)
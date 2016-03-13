module.exports = (bookshelf) ->

  Client = bookshelf.Model.extend(tableName: 'clients')
  ClientCoach = bookshelf.Model.extend(tableName: 'client_coach', idAttribute: 'client_id')

  get: (req, res) ->
    Client.forge().query(where: req.query).fetchAll()
      .then (collection) -> res.send(JSON.stringify(collection.models))
      .catch -> res.sendStatus(500)

  get_by_id: (req, res) ->
    Client.forge().query(where: id: req.params.id).fetch(require: yes)
      .then (client) ->
        ClientCoach.forge().query(where: client_id: req.params.id).fetch(require: yes)
          .then (client_coach) ->
            json = JSON.parse(JSON.stringify(client))
            json.coach_id = client_coach.get('coach_id')
            res.send(json)
          .catch -> res.sendStatus(500)
      .catch -> res.sendStatus(404)

  post: (req, res) ->
    Client.forge(email: req.body.email).fetch(require: yes)
      .then (client) ->
        res.status(403)
        res.send("/api/client/#{client.get('id')}")

      .catch ->
        Client.forge().save(req.body)
          .then (client) ->
            res.status(201)
            res.send("/api/client/#{client.get('id')}")
          .catch -> res.sendStatus(500)
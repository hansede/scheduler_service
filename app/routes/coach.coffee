module.exports = (bookshelf) ->

  Coach = bookshelf.Model.extend(tableName: 'coaches')
  ClientCoach = bookshelf.Model.extend(tableName: 'client_coach', idAttribute: 'client_id')

  get: (req, res) ->
    Coach.forge().query(where: req.query).fetchAll()
      .then (collection) -> res.send(JSON.stringify(collection.models))
      .catch -> res.sendStatus(500)

  get_by_id: (req, res) ->
    Coach.forge().query(where: id: req.params.id).fetch(require: yes)
      .then (coach) -> res.send(coach)
      .catch -> res.sendStatus(404)

  post: (req, res) ->
    Coach.forge(email: req.body.email).fetch(require: yes)
      .then (coach) ->
        res.status(403)
        res.send("/api/coach/#{coach.get('id')}")

      .catch ->
        Coach.forge().save(req.body)
          .then (coach) ->
            res.status(201)
            res.send("/api/coach/#{coach.get('id')}")
          .catch -> res.sendStatus(500)

  get_clients: (req, res) ->
    ClientCoach.forge().query(where: req.query).fetchAll()
      .then (collection) -> res.send(JSON.stringify(collection.models))
      .catch -> res.sendStatus(500)

  post_client: (req, res) ->
    params =
      client_id: req.body.client_id
      coach_id: req.params.coach_id

    ClientCoach.forge().save(params)
      .then -> res.sendStatus(201)
      .catch -> res.sendStatus(500)
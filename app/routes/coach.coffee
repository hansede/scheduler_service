module.exports = (bookshelf) ->

  Coach = bookshelf.Model.extend(tableName: 'coaches')

  get: (req, res) ->
    Coach.forge().query(where: req.query).fetchAll()
    .then (collection) -> res.send(JSON.stringify(collection.models))
    .catch -> res.sendStatus(500)

  post: (req, res) ->
    Coach.forge(req.body).save()
    .then (coach) ->
      res.status(201)
      res.send("/api/coach/#{coach.get('id')}")
    .catch -> res.sendStatus(500)
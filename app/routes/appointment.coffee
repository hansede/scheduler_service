module.exports = (bookshelf) ->

  Appointment = bookshelf.Model.extend(tableName: 'appointments')

  get: (req, res) ->
    Appointment.forge().query(where: req.query).fetchAll()
      .then (collection) -> res.send(JSON.stringify(collection.models))
      .catch -> res.sendStatus(500)

  post: (req, res) ->
    debugger
    req.body.appointment_date = new Date(parseInt(req.body.appointment_date))

    Appointment.forge(req.body).save()
      .then (appointment) ->
        res.status(201)
        res.send("/api/appointment/#{appointment.get('id')}")
      .catch -> res.sendStatus(500)
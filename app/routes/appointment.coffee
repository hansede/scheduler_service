module.exports = (bookshelf) ->

  Appointment = bookshelf.Model.extend(tableName: 'appointments')

  round_date = (time_stamp) ->
    time_stamp.setHours(0)
    time_stamp.setMinutes(0)
    time_stamp.setSeconds(0)
    time_stamp.setMilliseconds(0)
    time_stamp

  get: (req, res) ->
    Appointment.forge().query(where: req.query).fetchAll()
      .then (collection) -> res.send(JSON.stringify(collection.models))
      .catch -> res.sendStatus(500)

  get_by_coach_and_date: (req, res) ->
    start_date = round_date(new Date(parseInt(req.query.date))) # Round date to 00:00
    end_date = new Date(start_date)
    end_date.setDate(end_date.getDate() + 1) # 24 hours later
    end_date.setMilliseconds(end_date.getMilliseconds() - 1) # Minus one millisecond so we don't count the next day

    Appointment.forge().query('whereBetween', 'appointment_date', [start_date, end_date])
        .query(where: coach_id: req.params.coach_id).fetchAll()
      .then (collection) -> res.send(JSON.stringify(collection.models))
      .catch -> res.sendStatus(500)

  get_by_client: (req, res) ->
    Appointment.forge().query(where: client_id: req.params.client_id).fetch(require: yes)
      .then (appointment) -> res.send(appointment)
      .catch -> res.sendStatus(500)

  get_by_coach: (req, res) ->
    Appointment.forge().query(where: coach_id: req.params.coach_id).fetchAll()
      .then (collection) -> res.send(JSON.stringify(collection.models))
      .catch -> res.sendStatus(500)

  post: (req, res) ->
    req.body.appointment_date = new Date(parseInt(req.body.appointment_date))

    Appointment.forge().query(where: client_id: req.body.client_id).fetch(require: yes)
      .then (appointment) ->
        appointment.destroy()
          .then ->
            Appointment.forge(req.body).save()
              .then (appointment) ->
                res.status(201)
                res.send("/api/appointment/#{appointment.get('id')}")
              .catch -> res.sendStatus(500)
          .catch -> res.sendStatus(500)

      .catch ->
        Appointment.forge(req.body).save()
          .then (appointment) ->
            res.status(201)
            res.send("/api/appointment/#{appointment.get('id')}")
          .catch -> res.sendStatus(500)
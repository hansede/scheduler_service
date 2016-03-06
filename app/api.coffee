module.exports =

  init: (router, bookshelf) ->

    appointment = require('./routes/appointment')(bookshelf)
    router.get '/appointment', appointment.get
    router.get '/appointment/date/:date', appointment.get_by_date
    router.get '/client/:client_id/appointment', appointment.get_by_client
    router.get '/coach/:coach_id/appointment', appointment.get_by_coach
    router.post '/appointment', appointment.post

    client = require('./routes/client')(bookshelf)
    router.get '/client', client.get
    router.get '/client/:id', client.get_by_id
    router.post '/client', client.post

    coach = require('./routes/coach')(bookshelf)
    router.get '/coach', coach.get
    router.get '/coach/:id', coach.get_by_id
    router.post '/coach', coach.post
    router.get '/coach/:coach_id/client', coach.get_clients
    router.post '/coach/:coach_id/client', coach.post_client
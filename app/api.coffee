module.exports =

  init: (router, bookshelf) ->

    appointment = require('./routes/appointment')(bookshelf)
    router.get '/appointment', appointment.get
    router.post '/appointment', appointment.post

    client = require('./routes/client')(bookshelf)
    router.get '/client', client.get
    router.post '/client', client.post

    coach = require('./routes/coach')(bookshelf)
    router.get '/coach', coach.get
    router.post '/coach', coach.post
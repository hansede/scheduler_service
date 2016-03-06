gulp = require 'gulp'
exec = require('child_process').exec

gulp.task 'migrate', (cb) ->
  exec 'node ./node_modules/db-migrate/bin/db-migrate up -e postgres', (err, stdout, stderr) ->
    console.log(stdout)
    console.log(stderr)
    cb(err)
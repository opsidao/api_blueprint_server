app = require('express')()
settings = require './settings'
renderer = require './renderer'

app.get '/', (req, res, next) ->
  renderer.renderRoot(res)

app.get /\/.*/, (req, res, next) ->
  renderer.renderFile(res, req['originalUrl'])

server = app.listen settings.port, ->
  console.log 'Api blueprint server started'


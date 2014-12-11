express = require 'express'
app = express()
settings = require './settings'
stylus = require 'stylus'
nib = require('nib')
renderer = require './renderer'

app.set('views', __dirname + '/views')
app.set('view engine', 'jade')

app.use stylus.middleware
  src: __dirname + '/public'
  compile: (str, path) ->
    stylus(str).set('filename', path).use(nib())
app.use(express.static(__dirname + '/public'))

app.get '/', (req, res, next) ->
  renderer.renderRoot(res)

app.get /\/.*/, (req, res, next) ->
  renderer.renderFile(res, req['originalUrl'])

server = app.listen settings.port, ->
  console.log 'Api blueprint server started'


# Requires
express = require 'express'
basicAuth = require 'basic-auth-connect'
settings = require './lib/settings'
stylus = require 'stylus'
nib = require 'nib'

# Initialize app
app = express()

# Setup views
app.set('views', __dirname + '/app/views')
app.set('view engine', 'jade')

# Use stylus for stylesheets
app.use stylus.middleware
  src: __dirname + '/public'
  compile: (str, path) ->
    stylus(str).set('filename', path).use(nib())
app.use(express.static(__dirname + '/public'))

# Setup basic authentication
app.use basicAuth(settings.basic_auth_user, settings.basic_auth_password)

# Configure routes
app.get '/', require('./app/controllers/root').index
app.get /\/.*/, require('./app/controllers/blueprints').index

# Let's listen!
server = app.listen settings.port, ->
  console.log 'Api blueprint server started'


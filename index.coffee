aglio = require 'aglio'
GitHubApi = require 'github'
express = require('express')
app = express()

token = process.env.GITHUB_TOKEN
unless token?
  console.log 'You must set the GITHUB_TOKEN environment variable'
  process.exit -1

port = process.env.PORT

unless port?
  console.log 'You must set the PORT environment variable'
  process.exit -1

client = new GitHubApi version: '3.0.0'
client.authenticate type: 'oauth', token: token

renderFileAt = (res, path) ->
  repo_info =
    user: 'opsidao'
    repo: 'api_blueprint_test'
    path: path

  handle_response = (err, file) ->
    if err?
      res.send "Error: #{err['message']}"
    else unless file['content']?
      res.send "Not found"
    else
      blueprint = new Buffer(file['content'], 'base64').toString('utf8')
      aglio.render blueprint, 'slate-collapsible', (err, html, warnings) ->
        if err?
          console.log "Error rendering: #{err}"
        else
          res.send html

  client.repos.getContent repo_info, handle_response

app.get /\/.*/, (req, res, next) ->
  originalPath = req['originalUrl']
  renderFileAt(res, originalPath)

server = app.listen port, ->
  console.log 'Api blueprint server started'


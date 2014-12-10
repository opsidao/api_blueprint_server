aglio = require 'aglio'
settings = require './settings'
GitHubApi = require 'github'

client = new GitHubApi version: '3.0.0'
client.authenticate type: 'oauth', token: settings.github_token

exports.renderFile = (res, path) ->
  repo_info =
    user: settings.repo_user
    repo: settings.repo_name
    path: path

  renderBlueprint = (err, file) ->
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

  client.repos.getContent repo_info, renderBlueprint


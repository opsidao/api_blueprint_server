aglio = require 'aglio'
settings = require './settings'
GitHubApi = require 'github'

client = new GitHubApi version: '3.0.0'
client.authenticate type: 'oauth', token: settings.github_token

repoInfo = (path) ->
  user: settings.repo_user
  repo: settings.repo_name
  path: path

exports.renderFile = (res, path) ->
  render = (err, file) ->
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

  client.repos.getContent repoInfo(path), render

exports.renderRoot = (res) ->
  render = (err, folderContents) ->
    if err?
      res.send "Error: #{err['message']}"
    else
      html = '<ul>'
      for file in folderContents
        fileName = file['name']
        html += "<li><a href='#{fileName}'>#{fileName}</a></li>"
      html += '</ul>'

      res.send html

  client.repos.getContent repoInfo(''), render

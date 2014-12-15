rfr = require 'rfr'

aglio = require 'aglio'

client = rfr 'lib/github_client'
settings = rfr 'lib/settings'

repoInfo = (path) ->
  user: settings.repo_user
  repo: settings.repo_name
  path: path

exports.index = (req, res) ->
  path = req['originalUrl']
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

rfr = require 'rfr'

aglio = require 'aglio'

cache = rfr 'lib/cache'
client = rfr 'lib/github_client'
settings = rfr 'lib/settings'

repoInfo = (path) ->
  user: settings.repo_user
  repo: settings.repo_name
  path: path

exports.index = (req, res) ->
  path = req.params.file_name
  cache_key = "blueprints-#{path}"

  render = (err, file) ->
    if err?
      res.send "Error: #{err['message']}"
    else unless file['content']?
      res.send "Not found"
    else
      blueprint = new Buffer(file['content'], 'base64').toString('utf8')
      aglio.render blueprint, 'default', (err, html, warnings) ->
        if err?
          console.log "Error rendering: #{err}"
        else
          cache.set cache_key, html
          res.send html

  cached = cache.get(cache_key)[cache_key]

  if cached
    console.log "Serving cached path '#{path}'"
    res.send cached
  else
    console.log "Updating cache for path '#{path}'"
    client.repos.getContent repoInfo(path), render

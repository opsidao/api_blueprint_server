rfr = require 'rfr'

aglio = require 'aglio'

cache = rfr 'lib/cache'
client = rfr 'lib/github_client'
settings = rfr 'lib/settings'

repoInfo = (path, branch) ->
  user: settings.repo_user
  ref: if branch? then branch else 'master'
  repo: settings.repo_name
  path: path

exports.index = (req, res) ->
  path = req.params.file_name
  branch = req.param('branch')

  info = repoInfo(path, branch)

  cache_key = "#{info.ref}-#{path}-blueprints"

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
    console.log "Serving cached path '#{cache_key}'"
    res.send cached
  else
    console.log "Updating cache for path '#{cache_key}'"
    client.repos.getContent info, render

rfr = require 'rfr'

aglio = require 'aglio'

cache = rfr 'lib/cache'
client = rfr 'lib/github_client'
settings = rfr 'lib/settings'

exports.index = (req, res) ->
  dir = req.param('dir')
  dir = if dir? then "#{dir}/" else ''

  path = "#{dir}#{req.params.file_name}"
  branch = req.param('branch')

  info = settings.repo_info(branch, path)

  cache_key = "#{info.ref}-#{path}"

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
    blob_info = {
      user: info.user
      repo: info.repo
      sha: req.param('sha')
    }

    client.gitdata.getBlob blob_info, render

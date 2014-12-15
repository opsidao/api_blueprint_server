rfr = require 'rfr'

cache = rfr 'lib/cache'
githubClient = rfr 'lib/github_client'
settings = rfr 'lib/settings'

repoInfo =
  user: settings.repo_user
  repo: settings.repo_name
  path: ''

exports.index = (req, res) ->
  render = (err, folderContents) ->
    if err?
      res.send "Failed listing: #{err['message']}"
    else
      githubClient.logResponse folderContents
      files = folderContents.map (file) ->
        name: file['name']
        url: file['html_url']
      cache.set 'root', files
      res.render 'root/index', { files: files }

  cached = cache.get('root')['root']

  if cached
    console.log "Serving cached root: #{req}"
    res.render 'root/index', { files: cached }
  else
    console.log "Updating cache for root #{req}"
    githubClient.repos.getContent repoInfo, render

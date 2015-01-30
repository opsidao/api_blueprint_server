rfr = require 'rfr'

cache = rfr 'lib/cache'
githubClient = rfr 'lib/github_client'
settings = rfr 'lib/settings'

repoInfo =
  user: settings.repo_user
  ref: ''
  repo: settings.repo_name
  path: ''

exports.index = (req, res) ->
  branch = req.param('branch')
  repoInfo.ref = if branch? then branch else 'master'
  branches = [branch]

  files_cache_key = "root/#{repoInfo.ref}"
  branches_cache_key = 'root/branches'

  render = (err, folderContents) ->
    if err?
      res.send "Failed listing: #{err['message']}"
    else
      githubClient.logResponse folderContents
      files = folderContents.map (file) ->
        name: file['name']
        url: file['html_url']
      cache.set branches_cache_key, branches
      cache.set files_cache_key, files
      res.render 'root/index', { files: files, branch: repoInfo.ref, branches: branches }

  listBranches = (err, res) ->
    branches = res
    githubClient.repos.getContent repoInfo, render

  cached_files = cache.get(files_cache_key)[files_cache_key]

  if cached_files
    console.log "Serving cached root #{files_cache_key}"
    branches = cache.get(branches_cache_key)[branches_cache_key]
    res.render 'root/index', { files: cached_files, branch: repoInfo.ref, branches: branches}
  else
    console.log "Updating cache for root #{files_cache_key}"
    githubClient.repos.getBranches repoInfo, listBranches


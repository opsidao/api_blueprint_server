rfr = require 'rfr'

cache = rfr 'lib/cache'
githubClient = rfr 'lib/github_client'
settings = rfr 'lib/settings'

exports.index = (req, res) ->
  dir = req.param('dir')
  branch = req.param('branch')
  branches = [branch]

  info = settings.repo_info(branch, dir)

  files_cache_key = "root/#{info.ref}/#{dir}"
  branches_cache_key = 'root/branches'

  render = (err, folderContents) ->
    if err?
      res.send "Failed listing: #{err['message']}"
    else
      githubClient.logResponse folderContents
      files = folderContents.map (file) ->
        name: file['name']
        path: file['path']
        url:  file['html_url']
        type: file['type']
        dir: req.param('dir')

      files = files.sort (a, b) ->
        if a['type'] == b['type']
          if a['name'] > b['name']
            1
          else
            -1
        else
          if a['type'] == 'dir'
            -1
          else
            1

      cache.set branches_cache_key, branches
      cache.set files_cache_key, files
      res.render 'root/index', { files: files, branch: info.ref, branches: branches }

  listBranches = (err, res) ->
    branches = res
    githubClient.repos.getContent info, render

  cached_files = cache.get(files_cache_key)[files_cache_key]

  if cached_files
    console.log "Serving cached root #{files_cache_key}"
    branches = cache.get(branches_cache_key)[branches_cache_key]
    res.render 'root/index', { files: cached_files, branch: info.ref, branches: branches}
  else
    console.log "Updating cache for root #{files_cache_key}"
    githubClient.repos.getBranches info, listBranches

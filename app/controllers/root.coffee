rfr = require 'rfr'

client = rfr 'lib/github_client'
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
      files = folderContents.map (file) ->
        name: file['name']
        url: file['html_url']
      res.render 'root/index', { files: files }

  client.repos.getContent repoInfo, render

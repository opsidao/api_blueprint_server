rfr = require 'rfr'

settings = rfr 'lib/settings'
GitHubApi = require 'github'

client = new GitHubApi version: '3.0.0'
client.authenticate type: 'oauth', token: settings.github_token

module.exports = client

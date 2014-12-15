rfr = require 'rfr'

settings = rfr 'lib/settings'
GitHubApi = require 'github'

client = new GitHubApi version: '3.0.0'
client.authenticate type: 'oauth', token: settings.github_token

client.logResponse = (response) ->
  limit = response.meta['x-ratelimit-limit']
  remaining = response.meta['x-ratelimit-remaining']
  resets_at = new Date(0)
  resets_at.setUTCSeconds(response.meta['x-ratelimit-reset'])

  console.log "#{remaining} of #{limit} requests remaining until #{resets_at}"

module.exports = client

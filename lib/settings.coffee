settings =
  basic_auth_user: process.env.BASIC_AUTH_USER
  basic_auth_password: process.env.BASIC_AUTH_PASSWORD
  port: process.env.PORT
  github_token: process.env.GITHUB_TOKEN
  repo_user: process.env.REPO_USER
  repo_name: process.env.REPO_NAME

missing_settings_count = 0
for setting of settings
  unless settings[setting]?
    missing_settings_count++
    console.log "Missing environment variable #{setting.toUpperCase()}"

if missing_settings_count > 0
  process.exit 1

exports.basic_auth_user = settings['basic_auth_user']
exports.basic_auth_password = settings['basic_auth_password']
exports.github_token = settings['github_token']
exports.port = settings['port']
exports.repo_name = settings['repo_name']
exports.repo_user = settings['repo_user']

exports.repo_info = (branch, path) ->
  user: settings['repo_user']
  ref: if branch? then branch else 'master'
  repo: settings['repo_name']
  path: if path? then path else ''
  sha: ''

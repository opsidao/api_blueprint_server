settings =
  port: process.env.PORT
  token: process.env.GITHUB_TOKEN
  repo_user: process.env.REPO_USER
  repo_name: process.env.REPO_NAME

missing_settings_count = 0
for setting of settings
  unless settings[setting]?
    missing_settings_count++
    console.log "Missing environment variable #{setting.toUpperCase()}"

if missing_settings_count > 0
  process.exit 1

exports.github_token = settings['token']
exports.port = settings['port']
exports.repo_name = settings['repo_name']
exports.repo_user = settings['repo_user']

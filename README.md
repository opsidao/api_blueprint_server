# [API Blueprint](https://apiblueprint.org/) server

This is a very simple node application that will easily allow you to
publish a Github repository populated with API blueprints to a Heroku
Dyno.

Notice that I basically have no idea about node so you wouldn't be too precautious
if you checked the code before using this... you've been warmed ;)

## Configuration

All the configuration is made using environment variables, and all the
settings are required:

- BASIC_AUTH_USER: Username for the HTTP basic authentication required to
  acces the app.
- BASIC_AUTH_PASSWORD: Password for the HTTP basic authentication
  required to access the app.
- PORT: Port to listen to on run (This is set for you on heroku).
- GITHUB_TOKEN: The Oauth token to access github. You can create one for
  this application [here](https://github.com/settings/tokens/new). You
  should give this token the repo and/or the public_repo scopes,
  depending on wether your source repository is private or not.
- REPO_USER: The user part of your repository (i.e. your username or
  organization name).
- REPO_NAME: The name of the repository.

## Wishlist

- Integrate a testing framework and start testing stuff ([Vows.js](vowsjs.org)
  looks interesting, maybe with the [should](https://www.npmjs.com/package/should)
  package).
- Allow to serve a local folder, to use it during development.
- Login with Github, requiring access to the served repository to access
  the site.
- Branch support so you can preview your pull requests before merging
  them.
- Custom theme support, to allow branding of the site.
- Proper layout.
- Improved logging.

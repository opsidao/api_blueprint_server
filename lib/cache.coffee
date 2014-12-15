NodeCache = require 'node-cache'

cache = new NodeCache(stdTTL: 60)

module.exports = cache

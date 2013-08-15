crunchbase = require "crunchbase"
url = require "url"

exports.init = () ->
  # configure crunchbase api and find location
  cache = true
  if process.env.REDISCLOUD_URL
    redisURL = url.parse process.env.REDISCLOUD_URL
    cache = 
      host: redisURL.hostname
      port: redisURL.port
      auth: redisURL.auth.split(":")[1]
      options:
        no_ready_check: true

  crunchbase.init process.env.CRUNCHBASE_KEY

  return crunchbase


angellist = require "angellist"
url = require "url"

exports.init = () ->
  # configure angellist api and find location
  cache = true
  if process.env.REDISCLOUD_URL
    redisURL = url.parse process.env.REDISCLOUD_URL
    cache = 
      host: redisURL.hostname
      port: redisURL.port
      auth: redisURL.auth.split(":")[1]
      options:
        no_ready_check: true

  angellist.init process.env.ANGELLIST_CLIENT_ID, process.env.ANGELLIST_CLIENT_SECRET, cache

  return angellist


angellist = require "angellist"
url = require "url"

exports.init = () ->
  # configure angellist api and find location
  cache = true
  if process.env.REDIS_URL
    redisURL = url.parse process.env.REDIS_URL
    cache = 
      host: redisURL.hostname
      port: redisURL.port
      options:
        no_ready_check: true
    cache.auth = redisURL.auth.split(":")[1] if redisURL.auth

  if process.env.REDIS_1_PORT_6379_TCP_ADDR
    cache =
      host: process.env.REDIS_1_PORT_6379_TCP_ADDR
      port: process.env.REDIS_1_PORT_6379_TCP_PORT
      options:
        no_ready_check: true
    cache.auth = false

  angellist.init process.env.ANGELLIST_CLIENT_ID, process.env.ANGELLIST_CLIENT_SECRET, cache

  return angellist


redis = require "redis"
url = require "url"

class RedisClient

  constructor: () ->
    cache = true

    if process.env.REDISCLOUD_URL
      redisURL = url.parse process.env.REDISCLOUD_URL
      cache = 
        host: redisURL.hostname
        port: redisURL.port
        auth: redisURL.auth.split(":")[1]
        options:
          no_ready_check: true

    @client = redis.createClient cache.port, cache.host, cache.options
    @client.auth cache.auth if cache.auth

  addSet: (path, data, cb) ->
    @client.del path, (err) =>
      console.log err if err

      for item in data
        if not item.data.hidden
          item.id = "#{path}-#{item.data.id}"
          item.type = path

          # set with ids unsorted
          @client.sadd path, item.id

          # sorted set with ids by date
          if item.data.created_at?
            @client.zadd "bydate", -Date.parse(item.data.created_at), item.id

          @client.set item.id, JSON.stringify item

      cb err, data

  getSet: (path, cb) ->
    @getIds path, (err, results) =>
      get = []
      get.push(["get", id]) for id in results

      @client.multi(get).exec (err, replies) ->
        cb(err, replies.map (reply) -> JSON.parse reply)

  getIds: (path, cb) ->
    @client.smembers path, cb

  getByDate: (cb) ->
    @client.zrangebyscore "bydate", "-inf", "+inf", (err, results) =>
      get = []
      get.push(["get", id]) for id in results

      @client.multi(get).exec (err, replies) ->
        cb(err, replies.map (reply) -> JSON.parse reply)


module.exports = RedisClient


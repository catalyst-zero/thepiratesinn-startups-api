RedisClient = require("./lib/redis-client")

client = new RedisClient()

feeds = {}

feeds.get = (req, res) ->
  res.json {}

feeds.save = (req, res) ->
  res.send 200

feeds.query = (req, res) ->
  client.getByDate (err, results) ->
    res.json results

feeds.remove = (req, res) ->
  res.send 200

module.exports = feeds

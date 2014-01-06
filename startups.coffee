RedisClient = require("./lib/redis-client")

client = new RedisClient()

startups = {}

startups.get = (req, res) ->
  res.json {}

startups.save = (req, res) ->
  res.send 200

startups.query = (req, res) ->
  client.getSet "startups", (err, results) ->
    res.json results

startups.remove = (req, res) ->
  res.send 200

module.exports = startups

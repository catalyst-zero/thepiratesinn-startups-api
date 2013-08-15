RedisClient = require("./lib/redis-client")

client = new RedisClient()

users = {}

users.get = (req, res) ->
  res.json {}

users.save = (req, res) ->
  res.send 200

users.query = (req, res) ->
  client.getSet "users", (err, results) ->
    res.json results

users.remove = (req, res) ->
  res.send 200

module.exports = users

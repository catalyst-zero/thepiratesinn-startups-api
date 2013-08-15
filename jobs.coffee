RedisClient = require("./lib/redis-client")
client = new RedisClient()

jobs = {}

jobs.get = (req, res) ->
  res.json {}

jobs.save = (req, res) ->
  res.send 200

jobs.query = (req, res) ->
  client.getSet "jobs", (err, results) ->
    res.json results

jobs.remove = (req, res) ->
  res.send 200

module.exports = jobs

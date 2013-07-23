angel = require "./lib/angel"
location = require "./lib/location"

angellist = angel.init()

jobs = {}

jobs.get = (req, res) ->
  res.json {}

jobs.save = (req, res) ->
  res.send 200

jobs.query = (req, res) ->
  location.get (err, location_tag) ->
    res.json {} if not location_tag

    angellist.getTagsJobs {id: location_tag}, (err, results) ->
      res.json results.jobs

jobs.remove = (req, res) ->
  res.send 200

module.exports = jobs

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

    params = {id: location_tag}
    params.page = req.query.page if req.query.page

    angellist.getTagsJobs params, (err, results) ->
      res.json results

jobs.remove = (req, res) ->
  res.send 200

module.exports = jobs

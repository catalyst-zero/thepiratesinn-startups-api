angel = require "./lib/angel"
location = require "./lib/location"

angellist = angel.init()

startups = {}

startups.get = (req, res) ->
  res.json {}

startups.save = (req, res) ->
  res.send 200

startups.query = (req, res) ->
  location.get (err, location_tag) ->
    res.json {} if not location_tag

    angellist.getTagsStartups {id: location_tag}, (err, results) ->
      res.json results.startups

startups.remove = (req, res) ->
  res.send 200

module.exports = startups

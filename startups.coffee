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

    params = {id: location_tag}
    params.page = req.query.page if req.query.page

    angellist.getTagsStartups params, (err, results) ->
      res.json results

startups.remove = (req, res) ->
  res.send 200

module.exports = startups

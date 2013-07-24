angel = require "./lib/angel"
location = require "./lib/location"

angellist = angel.init()

users = {}

users.get = (req, res) ->
  res.json {}

users.save = (req, res) ->
  res.send 200

users.query = (req, res) ->
  location.get (err, location_tag) ->
    res.json {} if not location_tag

    params = {id: location_tag}
    params.page = req.query.page if req.query.page

    angellist.getTagsUsers params, (err, results) ->
      res.json results

users.remove = (req, res) ->
  res.send 200

module.exports = users

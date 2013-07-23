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

    angellist.getTagsUsers {id: location_tag}, (err, results) ->
      res.json results.users

users.remove = (req, res) ->
  res.send 200

module.exports = users

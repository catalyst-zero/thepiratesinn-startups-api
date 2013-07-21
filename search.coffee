angellist = require "angellist"

angellist.init process.env.ANGELLIST_CLIENT_ID, process.env.ANGELLIST_CLIENT_SECRET

search = {}

search.get = (req, res) ->
  res.json {}

search.save = (req, res) ->
  res.send 200

search.query = (req, res) ->
  angellist.search req.query.q, (err, results) ->
    console.log err
    res.json results

search.remove = (req, res) ->
  res.send 200

module.exports = search

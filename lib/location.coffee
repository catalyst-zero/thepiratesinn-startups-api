angel = require "./angel"

location = undefined
angellist = angel.init()

exports.get = (callback) ->
  if location? 
    process.nextTick () ->
      callback null, location 
  else 
    angellist.getSearch {query: "cologne", type: "LocationTag"}, (err, result) ->
      return if not result
      location = result[0].id
      callback err, location



angellist = require("./angel").init()
crunchbase = require("./crunch").init()
location = require "./location"

RedisClient = require("./redis-client")
client = new RedisClient()

# method: API method
# path: Object path in JSON response from API
# query: Parameter for the API call
fetchAllPages = (method, path, query, cb, result = []) ->
  query.page = 1 if not query.page?

  tmp = {}
  for key of query
    tmp[key] = query[key]

  # fetch data from api
  angellist[method] tmp, (err, results) ->
    return cb(err) if err

    result.push(
      data: item
      query: query
    ) for item in results[path]

    if results.page >= results.last_page
      # on last page store data in redis
      return client.addSet path, result, cb

    # fetch next page
    query.page++
    fetchAllPages method, path, query, cb, result

fetchAll = (method, path, startups, cb, result = []) ->
  done = 0

  for startup in startups
    id = startup.id.split("-")[1]
    query = startup_id: id
    angellist[method] query, (err, results) ->
      result.push(
        data: item
        query: query
        startup: startup.data
      ) for item in results[path] if results.total > 0
      done++

      if done >= startups.length
        return client.addSet path, result, cb

exports.init = (cb) ->
  location.get (err, location_tag) ->
    callback = (err, results) -> console.log err if err
    query = id: location_tag

    # ugly: use async here
    fetchAllPages "getTagsStartups", "startups", query, (err) ->
      console.log err if err
      fetchAllPages "getTagsUsers", "users", query, (err) ->
        console.log err if err
        fetchAllPages "getTagsJobs", "jobs", query, (err) ->
          console.log err if err

          client.getSet "startups", (err, startups) =>
            # fetch all status updates
            fetchAll "getStatusUpdates", "status_updates", startups, (err) ->
              console.log err if err
              fetchAll "getStartupPress", "press", startups, (err) ->
                console.log err if err
                cb()

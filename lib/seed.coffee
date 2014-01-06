angellist = require("./angel").init()
location = require "./location"

RedisClient = require("./redis-client")
client = new RedisClient()

# method: API method
# path: Object path in JSON response from API
# query: Parameter for the API call
fetchAllPages = (method, path, query, cb, result = []) ->
  query.page = 1 if not query.page?

  # this is ridiculous, but necessary since the query object is 
  # altered in the angellist module and here for pagination
  query_for_angellist = {}
  for key of query
    query_for_angellist[key] = query[key]
  query_for_pagination = {}
  for key of query
    query_for_pagination[key] = query[key]

  # fetch data from api
  angellist[method] query_for_angellist, (err, results) ->
    return cb(err) if err

    result.push(
      data: item
      query: query_for_angellist
    ) for item in results[path]

    if results.page >= results.last_page
      # on last page store data in redis
      return client.addSet path, result, cb

    # fetch next page
    query_for_pagination.page++
    fetchAllPages method, path, query_for_pagination, cb, result

fetchAll = (method, path, startups, cb, result = []) ->
  done = 0

  startups.forEach (startup) ->
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

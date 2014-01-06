express = require 'express'
http = require 'http'
path = require 'path'
angularResource = require "angular-resource"
cors = require "cors"

seed = require "./lib/seed"

app = express()

app.set 'port', process.env.PORT || 3000
app.use express.favicon()
app.use express.logger('dev')
app.use express.cookieParser()
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.session secret: process.env.SESSION_SECRET
app.use cors({origin: true, credentials: true, headers: ['X-Requested-With']})

timestamp = Date.now()
app.use((req, res, next) ->
  now = Date.now()

  if now > (timestamp + 3600000)
    seed.init () ->
      console.log "seeding update successful"
  next()
)

app.use app.router
app.use express.static(path.join(__dirname, 'public'))

if ('development' == app.get('env'))
  app.use(express.errorHandler())

angularResource app, '/api/1', 'feeds'
angularResource app, '/api/1', 'startups'
angularResource app, '/api/1', 'users'
angularResource app, '/api/1', 'jobs'

seed.init () ->
  console.log "initial seeding successful"
  http.createServer(app).listen app.get('port'), () ->
    console.log('Express server listening on port ' + app.get('port'))

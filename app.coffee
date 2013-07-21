express = require('express')
http = require('http')
path = require('path')
passport = require "passport"
AngellistStrategy = require("passport-angellist").Strategy
models = require "./lib/models"
angellist = require "angellist"
angularResource = require "angular-resource"
cors = require "cors"

angellist.init process.env.ANGELLIST_CLIENT_ID, process.env.ANGELLIST_CLIENT_SECRET

app = express()

app.set 'port', process.env.PORT || 3000
app.use express.favicon()
app.use express.logger('dev')
app.use express.cookieParser()
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.session secret: process.env.SESSION_SECRET
app.use cors({origin: true, credentials: true, headers: ['X-Requested-With']})

app.use passport.initialize()
app.use passport.session()

passport.serializeUser (user, done) ->
  done null, user.id

passport.deserializeUser (id, done) ->
  models.Users.findById id, (err, user) ->
    done err, user

passport.use(new AngellistStrategy({
    clientID: process.env.ANGELLIST_CLIENT_ID
    clientSecret: process.env.ANGELLIST_CLIENT_SECRET
    callbackURL:  "#{process.env.BASE_URI}/auth/angellist/callback"
  }, 
  (accessToken, refreshToken, profile, done) ->
    find = angellist_id: profile.id
    save = 
      angellist_id: profile.id
      name: profile._json.name
      email: profile._json.email
      avatar_url: profile._json.image
    options = upsert: true

    models.Users.findOneAndUpdate find, save, options, (err, user) ->
      done err, user
))

app.use app.router
app.use express.static(path.join(__dirname, 'public'))

if ('development' == app.get('env'))
  app.use(express.errorHandler())

authenticated = (req, res, next) ->
  if req.isAuthenticated()
    next()
  else
    res.send 401

app.get '/', authenticated, (req, res) ->
  res.json {hello: "world"}

rememberRedirect = (req, res, next) ->
  req.session.redirect_to = req.query.redirect
  next()

app.get '/auth/angellist', rememberRedirect, 
  passport.authenticate('angellist', failureRedirect: '/'), (req, res) ->

app.get '/auth/angellist/callback',
  passport.authenticate('angellist'), (req, res) ->
    res.redirect req.session.redirect_to || '/account'

app.get '/logout', (req, res) ->
  req.logout()
  res.redirect req.query.redirect || '/'

app.get '/account', authenticated, (req, res) ->
  res.send user: req.user

angularResource app, '/api/1', 'search', authenticated

http.createServer(app).listen(app.get('port'), () ->
  console.log('Express server listening on port ' + app.get('port'))
)

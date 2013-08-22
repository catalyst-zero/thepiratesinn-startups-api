passport = require "passport"
AngellistStrategy = require("passport-angellist").Strategy

class AngellistAuth

  constructor: (@app, @models) ->
    @app.use passport.initialize()

    @handleSession()
    @applyStrategy()

  handleSession: () ->
    @app.use passport.session()

    passport.serializeUser (user, done) ->
      done null, user.id

    passport.deserializeUser (id, done) ->
      @models.Users.findById id, (err, user) ->
        done err, user

  applyStrategy: () ->
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
          avatar_url: profile._json.image
          access_token: accessToken
        options = upsert: true

        @models.Users.findOneAndUpdate find, save, options, (err, user) ->
          done err, user
    ))

  addRoutes: () ->
    @app.get '/auth/angellist', AngellistAuth.rememberRedirect, 
      passport.authenticate('angellist', failureRedirect: '/'), (req, res) ->

    @app.get '/auth/angellist/callback',
      passport.authenticate('angellist'), (req, res) ->
        res.redirect req.session.redirect_to || '/account'

    @app.get '/logout', (req, res) ->
      req.logout()
      res.redirect req.query.redirect || '/'

    @app.get '/account', AngellistAuth.authenticated, (req, res) ->
      res.send user: req.user

  @rememberRedirect: (req, res, next) ->
    req.session.redirect_to = req.query.redirect
    next()

  @authenticated: (req, res, next) ->
    if req.isAuthenticated()
      next()
    else
      res.send 401


module.exports = AngellistAuth

mongoose = require "mongoose"

mongoose.connect process.env.MONGOHQ_URL || "mongodb://localhost/angellist"

UserSchema = new mongoose.Schema
  angellist_id: String
  email: String
  name: String
  avatar_url: String
  access_token: String

exports.Users = mongoose.model "users", UserSchema

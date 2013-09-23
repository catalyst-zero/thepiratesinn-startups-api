# The Pirates Inn Startups API

A simple API wrapper for Angellist. Fetches all the Angellist information about city (location tag within Angellist) and caches it for a day.

## Install

Clone this repository

    git clone https://github.com/d27y/thepiratesinn-startups-api
    cd thepiratesinn-startups-api

Install the necessary npm modules.

    npm install

## Dependencies

Redis and MongoDB are required to run the API.

## Environment

You need to configure your environment to contain the following variables. 

* SESSION\_SECRET (random string to salt the session)
* ANGELLIST\_CLIENT\_ID (angellist api auth)
* ANGELLIST\_CLIENT\_SECRET (angellist api auth)
* BASE\_URI (url for the api)
* MONGOHQ\_URL (uses localhost if not specified)
* REDISCLOUD\_URL (uses localhost if not specified)

## Development

Use foreman to run the application locally. You need to set up some environment variables. Create an ``.env`` file in this folder and add all the necessary environment variables.

    foreman start web

## Deployment

It is easy to deploy this api on Heroku or Dokku. Just add the Redis and MongoDB Addons to your app and configure the Heroku environment. Push your code and install the [webapp](https://github.com/d27y/thepiratesinn-startups).

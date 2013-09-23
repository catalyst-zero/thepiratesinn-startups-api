# The Pirates Inn Startups API

A simple API wrapper for Angellist. Fetches all the Angellist information about city (location tag within Angellist) and caches it for a day.

## Install

Clone this repository

    git clone https://github.com/d27y/thepiratesinn-startups
    cd thepiratesinn-startups

Install the necessary node and client modules.

    npm install
    bower install

## Development

Use grunt to run the application locally. It watches for local changes and reloads the browser automatically.

    npm install -g grunt
    grunt server

## Deployment

This application is a simple static HTML / Javascript page. To deploy on a Paas like Heroku you need a static webserver. The static webserver is in /dokku (dokku is an open source mini-heroku). 

    grunt build

The application is now compiled in the /dist folder. To deploy to heroku make /dist a separate git repository and push the code. Same for dokku.


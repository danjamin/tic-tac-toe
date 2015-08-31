## Tic-tac-toe [![Build Status](https://travis-ci.org/danjamin/tic-tac-toe.svg?branch=master)](https://travis-ci.org/danjamin/tic-tac-toe)

Tic-tac-toe is an Ember implementation of tic tac toe.

As a player, you get to go first, and the computer will play against your moves
using an AI algorithm that can NOT lose -- at best, you can tie with it.

Example app served at http://danjamin-tic-tac-toe.herokuapp.com/

## Stack

* Scaffolded via [ember-cli](http://iamstef.net/ember-cli/)
* Primarily written in [Ember.js](http://emberjs.com/) and [CoffeeScript](http://coffeescript.org/)
* Styles written in [Sass](http://sass-lang.com/)
* Front-end dependency management via [Bower](http://bower.io/)
* Build and back-end dependencies managed via [npm](https://www.npmjs.org/)
* Deployed to and hosted by [heroku](http://heroku.com/)

## Installation

    $ git clone {this repository}
    $ npm install
    $ bower install

## Running

    $ npm start

Visit your app at http://localhost:4200.

## Running Tests

To run command line tests you will **need phantomjs installed globally**

    $ sudo npm install -g phantomjs

You can run once via

    $ npm test

You can continue to serve the tests via:

    $ ./node_modules/.bin/ember test --server

Alternatively, you can visit http://localhost:4200/tests after

    $ npm start

## Staging locally

Install production dependencies

    $ npm prune --production
    $ npm install --production
    $ bower prune --production
    $ bower install --production

Build the `dist` version of the app

    $ ./node_modules/.bin/ember build --environment production

Run foreman server

    $ foreman start

## Deploying

Login and create the heroku remote

    $ heroku login
    $ heroku create

Use the correct build pack:

    $ heroku config:set BUILDPACK_URL=https://github.com/tonycoco/heroku-buildpack-ember-cli.git#870dc93154547e753e4de2d02c149b8f7bc3dca8

Deploy the app

    $ git push heroku master

## Monitoring

View the dynos

    $ heroku ps

View the logs

    $ heroku logs

View the app

    $ heroku open

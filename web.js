// web.js
var express = require("express");
var logfmt = require("logfmt");

var server;
var port;

// create the server itself
server = express();

// set the port to be used
port = Number(process.env.PORT || 5000);

// setup the logger
server.use(logfmt.requestLogger());

// serve files under ./public
server.use(express.static(__dirname + '/dist'));

// optionally serve an api
// server.get('/api', function(req, res) {
//   res.send('Hello World!');
// });

// start listening
server.listen(port, function() {
  console.log("Listening on " + port);
});

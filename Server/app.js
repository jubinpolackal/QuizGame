var http = require("http");
var express = require("express");
var fs = require('fs');
var path = require('path');
var bodyParser = require('body-parser');

const app = express();

// Parsers
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false}));

// Angular DIST output folder
app.use(express.static(path.join(__dirname, 'dist')));

// Send all other requests to the Angular app
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, 'Content/content.json'));
});

//Set Port
const port = process.env.PORT || '3000';
app.set('port', port);



const server = http.createServer(app);

server.listen(port, () => {
  console.log('News Quiz server started');
});
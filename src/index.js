'use strict';

require('./css/main.scss');

// Require index.html so it gets copied to dist
require('./index.html');

var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

// .embed() can take an optional second argument. This would be an object describing the data we need to start a program, i.e. a userID or some token
var app = Elm.Main.embed(mountNode, {
  githubBaseUrl: 'https://api.github.com',
  token: localStorage.getItem('token')
});

// store successful tokens in local storage
app.ports.storeToken.subscribe(function(token) {
  localStorage.setItem('token', token);
});

// reset token in local storage
app.ports.clearToken.subscribe(function() {
  localStorage.removeItem('token');
});

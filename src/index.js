'use strict';

require("./styles/app.scss");

const { Elm } = require('./Main');

var app = Elm.Main.init({ flags: 6 });

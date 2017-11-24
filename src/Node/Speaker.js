"use strict";

var Speaker = require('speaker');

exports.mkSpeaker = function() {
  return new Speaker();
};

exports.mkSpeakerWithOptions = function() {
  return function(opts) {
    return new Speaker(opts);
  };
};

exports.onOpen = function(speaker) {
  return function(cb) {
    return function() {
      speaker.on('open', cb);
    };
  };
};

exports.onFlush = function(speaker) {
  return function(cb) {
    return function() {
      speaker.on('flush', cb);
    };
  };
};

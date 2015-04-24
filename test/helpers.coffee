exports.chai = require "chai"
exports.expect = exports.chai.expect
rewire = require "rewire"

exports.require = (name) ->
  require "../coffee/#{name}"

exports.rewire = (name) ->
  rewire "../coffee/#{name}"

exports.random = ->
  Math.floor Math.random() * 1000

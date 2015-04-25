exports.chai = require "chai"
exports.expect = exports.chai.expect
exports.sinon = require "sinon"
require "sinon-as-promised"
exports.chai.use require "sinon-chai"
exports.chai.use require "chai-as-promised"
rewire = require "rewire"

exports.require = (name) ->
  require "../coffee/#{name}"

exports.rewire = (name) ->
  rewire "../coffee/#{name}"

exports.random = ->
  Math.floor Math.random() * 1000

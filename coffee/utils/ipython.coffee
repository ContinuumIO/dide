_ = require "underscore"
Q = require "q"

execute = (code) ->
  deferred = Q.defer()
  _.defer ->
    deferred.resolve "<code><pre>#{code}</pre></code>"
  deferred.promise

module.exports =
  execute: execute

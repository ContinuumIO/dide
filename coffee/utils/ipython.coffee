_ = require "underscore"
Q = require "q"
http = require "http"

execute = (code) ->
  deferred = Q.defer()
  options =
    method: "POST"
    hostname: "127.0.0.1"
    port: 5151
    path: "/"
    headers:
      "Content-Type": "text/plain"
      "Content-Length": code.length

  req = http.request options, (res) ->
    raw = ""
    res.setEncoding "utf8"
    res.on "data", (chunk) ->
      raw += chunk
    res.on "end", ->
      data = JSON.parse raw
      # TODO deal with images
      if data.html?
        deferred.resolve data.html
      else
        deferred.resolve "<code><pre>#{data.output}</pre></code>"
  req.write code
  req.end()

  deferred.promise

module.exports =
  execute: execute

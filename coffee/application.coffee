_ = require "underscore"
$ = require "jquery"
net = require "net"
{AppDispatcher} = require "./dispatchers"

setupGlobals = (g, win) ->
  g = _.extend g,
    window: win.window
    document: win.window.document
    navigator: win.window.navigator

configureReload = (document) ->
  client = net.connect {port: 35729}, ->
    console.debug "livereload server detected, adding"
    script = document.createElement "script"
    script.src = "http://localhost:35729/livereload.js"
    document.body.appendChild script
  client.on "error", ->
    console.debug "no livereload server detected, skipping"

module.exports = (gui) ->
  win = gui.Window.get()
  win.showDevTools()

  $(window).ready ->
    setupGlobals global, win
    configureReload win.window.document
    require("./components/app")(window.document.body)

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
    script = document.createElement "script"
    script.src = "http://localhost:35729/livereload.js"
    document.body.appendChild script

module.exports = (gui) ->
  win = gui.Window.get()
  win.showDevTools()

  nativeMenuBar = new gui.Menu type: "menubar"
  try
    nativeMenuBar.createMacBuiltin "Dide"
    win.menu = nativeMenuBar
  catch ex
    console.log ex.message

  $(window).ready ->
    setupGlobals global, win
    configureReload win.window.document
    require("./components/app")(window.document.body)

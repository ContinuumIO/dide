_ = require "underscore"
$ = require "jquery"
{AppDispatcher} = require "./dispatchers"

setupGlobals = (g, win) ->
  g = _.extend g,
    window: win.window
    document: win.window.document
    navigator: win.window.navigator

module.exports = (gui) ->
  win = gui.Window.get()
  win.showDevTools()

  $(window).ready ->
    setupGlobals global, win
    require("./components/app")(window.document.body)

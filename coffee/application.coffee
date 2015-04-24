_ = require "underscore"
$ = require "jquery"

require("node-jsx").install()

setupGlobals = (g, win) ->
  g = _.extend g,
    window: win.window
    document: win.window.document
    navigator: win.window.navigator

onChange = ->
  console.log "onChange", arguments

module.exports = (gui) ->
  win = gui.Window.get()
  win.showDevTools()

  $(window).ready ->
    setupGlobals global, win

    React = require "react"
    AceEditor = require "react-ace"

    editor = React.createElement AceEditor,
      onChange: onChange
      name: "editor"
      mode: "markdown"
      theme: "github"
    React.render editor, window.document.body

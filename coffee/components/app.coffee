React = require "react"
{div} = React.DOM
AceEditor = require "react-ace"
{AppDispatcher} = require "../dispatchers"
{PreviewPane} = require "./preview"
{CardStack} = require "../models/cards"


Application = React.createClass
  displayName: "Application"

  renderEditor: ->
    stack = new CardStack()
    React.createElement AceEditor,
      onChange: (newContent) ->
        stack.parse newContent
        AppDispatcher.dispatch
          actionType: "content:changed"
          content: newContent
          stack: stack
      name: "editor"
      mode: "markdown"
      theme: "github"

  renderPreview: ->
    React.createElement PreviewPane

  render: ->
    (div {className: "row"},
      (div {className: "columns medium-6"}, @renderEditor()),
      (div {className: "columns medium-6"}, @renderPreview()),
    )


module.exports = (target) ->
  console.log "hi"
  app = React.createElement Application
  console.log app
  React.render app, target

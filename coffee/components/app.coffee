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
    (div {className: "dide-container"},
      (div {className: "editor"}, @renderEditor()),
      (div {className: "preview"}, @renderPreview()),
    )


module.exports = (target) ->
  app = React.createElement Application
  React.render app, target

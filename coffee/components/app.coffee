React = require "react"
{div} = React.DOM
AceEditor = require "react-ace"
{AppDispatcher} = require "../dispatchers"
{PreviewPane} = require "./preview"


Application = React.createClass
  displayName: "Application"

  renderEditor: ->
    React.createElement AceEditor,
      onChange: (newContent) ->
        AppDispatcher.dispatch
          actionType: "content:changed"
          content: newContent
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

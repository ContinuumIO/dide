React = require "react"
{div, span} = React.DOM
marked = require "marked"
{AppDispatcher} = require "../dispatchers"

marked.setOptions
  gfm: true

rawHtml = (html) ->
  (span {dangerouslySetInnerHTML: {__html: html}})

PreviewPane = React.createClass
  displayName: "PreviewPane"

  getInitialState: ->
    content: "Type something in the editor to the left"

  componentDidMount: ->
    @token = AppDispatcher.register (payload) =>
      @handleDispatch payload

  componentWillUnmount: ->
    AppDispatcher.unregister @token

  handleDispatch: (payload) ->
    switch payload.actionType
      when "content:changed"
        @setState content: payload.content

  getRenderedContent: ->
    rawHtml marked @state.content

  render: ->
    (div {className: "preview-container"},
      @getRenderedContent()
    )

module.exports =
  PreviewPane: PreviewPane

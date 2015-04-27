
React = require "react"
{div, span} = React.DOM
marked = require "marked"
{AppDispatcher} = require "../dispatchers"
{CardStack} = require "../models/cards"

marked.setOptions
  gfm: true

rawHtml = (html) ->
  (span {dangerouslySetInnerHTML: {__html: html}})

Card = React.createClass
  displayName: "Card"

  getInitialState: ->
    content: "Loading…"

  componentDidMount: ->
    console.log "Card.componentDidMount fired"
    @props.card.on "change", =>
      console.log "change fired"
      @renderCard()
    @renderCard()

  renderCard: ->
    @props.card.render()
      .then (content) =>
        console.log "got rendered content back: #{content}"
        @setState content: content

  render: ->
    rawHtml @state.content

PreviewPane = React.createClass
  displayName: "PreviewPane"

  getInitialState: ->
    content: "Type something in the editor to the left"
    stack: []

  componentDidMount: ->
    @token = AppDispatcher.register (payload) =>
      @handleDispatch payload

  componentWillUnmount: ->
    AppDispatcher.unregister @token

  handleDispatch: (payload) ->
    switch payload.actionType
      when "content:changed"
        @setState
          content: payload.content
          stack: payload.stack
        @forceUpdate()

  getRenderedContent: ->
    @state.stack.map (card) ->
      React.createElement Card, card: card

  render: ->
    (div {className: "preview-container"},
      @getRenderedContent()
    )

module.exports =
  PreviewPane: PreviewPane

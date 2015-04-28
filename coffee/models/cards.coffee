_ = require "underscore"
Backbone = require "backbone"
{AppDispatcher} = require "../dispatchers"
marked = require "marked"
Q = require "q"
ipython = require "../utils/ipython"

AppDispatcher.register (payload) ->
  switch payload.actionType
    when "content:changed"
      stack = new CardStack()
      stack.parse payload.content


class Card extends Backbone.Model
  render: ->
    deferred = Q.defer()
    # TODO What's a better way to discover what can handle it?
    if @get "isCode"
      ipython.execute @get "raw"
        .then deferred.resolve
    else
      _.defer =>
        deferred.resolve marked @get "raw"
    deferred.promise

class CardStack extends Backbone.Collection
  getOrAdd: (index, attributes) ->
    card = @at index
    if card
      card.set attributes
    else
      @add new Card attributes

  parse: (raw) ->
    trim = @models.length > 0

    currentIndex = 0
    data = []
    previous = false
    for line in raw.split "\n"
      # TODO Detect ``` lines as well
      indented = line[0...4] is "    "

      if previous is indented
        data.push line.trim()
        continue

      @getOrAdd currentIndex,
        raw: (data.join "\n").trim()
        isCode: !indented

      currentIndex++
      data = [line.trim(), ]
      previous = indented

    @getOrAdd currentIndex,
      raw: (data.join "\n").trim()
      isCode: indented  # TODO Why is this not inverted here?
    @models = _.without @models, @models[currentIndex + 1..]... if trim


module.exports =
  Card: Card
  CardStack: CardStack

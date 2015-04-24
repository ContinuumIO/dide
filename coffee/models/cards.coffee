Backbone = require "backbone"
{AppDispatcher} = require "../dispatchers"

AppDispatcher.register (payload) ->
  switch payload.actionType
    when "content:changed"
      stack = new CardStack()
      stack.parse payload.content


class Card extends Backbone.Model


class CardStack extends Backbone.Collection
  parse: (raw) ->
    data = []
    previous = false
    for line in raw.split "\n"
      indented = line[0...4] is "    "

      if previous is indented
        data.push line.trim()
        continue

      @add new Card raw: (data.join "\n").trim()
      data = [line.trim(), ]
      previous = indented

    @add new Card raw: (data.join "\n").trim()


module.exports =
  Card: Card
  CardStack: CardStack

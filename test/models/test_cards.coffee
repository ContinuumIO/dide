helpers = require "../helpers"
cards = helpers.rewire "models/cards"

{expect} = helpers

describe "CardStack", ->
  describe "simple markdown", ->
    stack = null
    markdown = "# Header Here!\n\nRandom Number: #{helpers.random()}"

    before ->
      stack = new cards.CardStack()
      stack.parse markdown

    it "should return one card when parsing simple Markdown", ->
      expect(stack.models.length).to.equal 1

    it "should contain the Card with rendered Markdown", ->
      expect(stack.at(0).get "raw").to.equal markdown

  describe "markdown with code", ->
    stack = null
    markdown = [
      "# Header here"
      ""
      "This is some paragraph text"
      ""
      "    import sys"
      "    print(sys.version)"
      ""
      "More *Markdown* here"
    ].join "\n"

    before ->
      stack = new cards.CardStack()
      stack.parse markdown

    it "should return three cards when Markdown, Python, Markdown", ->
      expect(stack.models.length).to.equal 3

    it "should contain just markdown in the first model", ->
      first = stack.at(0)
      expected = "# Header here\n\nThis is some paragraph text"
      expect(first.get "raw").to.equal expected

    it "should contain just python in the second model", ->
      second = stack.at(1)
      expected = "import sys\nprint(sys.version)"
      expect(second.get "raw").to.equal expected

    it "should contain just markdown in the third model", ->
      third = stack.at(2)
      expected = "More *Markdown* here"
      expect(third.get "raw").to.equal expected

describe "Card", ->

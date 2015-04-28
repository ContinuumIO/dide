helpers = require "../helpers"
_ = require "underscore"
Q = require "q"
cards = helpers.rewire "models/cards"

{expect, sinon} = helpers

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

    it "Should have isCode set to false on first model", ->
      expect(stack.at(0).get "isCode").to.be.false

    it "should have isCode set to true on second model", ->
      expect(stack.at(1).get "isCode").to.be.true

    it "Should have isCode set to false on third model", ->
      expect(stack.at(2).get "isCode").to.be.false

  describe "calling parse again", ->
    stack = null
    markdown = [
      "# Header here"
      ""
      "This is some paragraph text"
      ""
      "    import sys"
      "    print(sys.version)"
      ""
      "More *Markdown* here."
      "Some paragraphs here"
    ].join "\n"

    before ->
      stack = new cards.CardStack()
      stack.parse markdown

    it "should be the same length", ->
      originalLength = stack.models.length
      stack.parse markdown
      expect(stack.models.length).to.equal originalLength

    it "should provide the same model when parsing the same content", ->
      first = stack.at(0)
      stack.parse markdown
      firstAgain = stack.at(0)
      expect(first).to.deep.equal firstAgain

    it "should remove any models that aren't present", ->
      stack.parse "Just one *Markdown* item now"
      expect(stack.models.length).to.equal 1


describe "Card", ->
  describe "markdown", ->
    markdown = "Some basic markdown #{helpers.random()}"

    it "should have original text available as raw", ->
      card = new cards.Card raw: markdown
      expect(card.get "raw").to.equal markdown

    it "should return a promise when calling render", ->
      card = new cards.Card raw: markdown
      render = card.render()
      expect(card.render()).to.have.property "then"

    it "should fulfill the promise with rendered code", ->
      card = new cards.Card raw: markdown
      expected = "<p>#{markdown}</p>\n"
      expect(card.render()).to.eventually.equal expected

  describe "code", ->
    code = "import sys\nprint(sys.version)"

    it "should have original code available as raw", ->
      card = new cards.Card raw: code
      expect(card.get "raw").to.equal code

    it "should return a promise when calling render", ->
      card = new cards.Card raw: code
      render = card.render()
      expect(card.render()).to.have.property "then"

    it "should resolve with result of dispatched execution", (done) ->
      randomReturn = "random return: #{helpers.random()}"
      execute = sinon.stub()
      execute.resolves randomReturn

      mocks =
        ipython:
          execute: execute

      cards.__with__(mocks) ->
        card = new cards.Card raw: code, isCode: true
        card.render()
        expect(card.render()).to.eventually.equal(randomReturn).then ->
          expect(execute).to.have.been.calledWith code
          done()

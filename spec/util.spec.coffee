util = require '../coffee/util.coffee'

describe 'Util provides the following helper functions', ->

  describe 'logb', ->

    it 'returns the log with the given base of a number', ->
      expect(util.logb 8, 2).toBe 3

  describe 'log2', ->

    it 'returns the log base 2 of a number', ->
      expect(util.log2 8).toBe 3

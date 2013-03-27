dt = require('../coffee/decision_tree.coffee')
DecisionTreeLearner = dt.DecisionTreeLearner

describe 'A decision tree learner', ->
  dtl = undefined

  examples = [
    [1, 1, 0, 0, 1],
    [1, 0, 1, 0, 1],
    [0, 0, 0, 1, 0],
    [0, 1, 0, 1, 0]
  ]

  complexExamples = [
    [1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1],
    [0, 0, 0, 1, 0],
    [0, 1, 0, 1, 0],
    [1, 1, 0, 0, 0]
    [1, 1, 1, 0, 0]
  ]

  moreComplexExamples = [
    [1, 0, 1, 0, 1],
    [1, 0, 1, 0, 1],
    [0, 1, 0, 1, 1],
    [0, 0, 0, 1, 0],
    [1, 0, 0, 1, 0],
    [0, 1, 0, 1, 0],
    [1, 1, 0, 0, 0],
    [1, 1, 1, 0, 0]
  ]

  beforeEach ->
    @addMatchers {
      toBeAbout: (expected, accuracy=.01) ->
        @message = ->
          "Expected #{@actual}#{if @isNot then ' not' else ''} to be about #{expected}"
        Math.abs(@actual - expected) <= accuracy
    }

    dtl = new DecisionTreeLearner(examples)

  it 'can make a point estimate', ->
    pointEstimate = dtl.pointEstimate(examples)
    expect(pointEstimate).toBe .5

  it 'can find the information gain for a set of examples', ->
    expect(dtl.gain []).toBe 0
    expect(dtl.gain [[1], [1]]).toBe 0
    expect(dtl.gain [[1], [0]]).toBe 1
    expect(dtl.gain [[1], [0], [0]]).toBeAbout .92
    expect(dtl.gain [[1], [1], [1], [1], [0], [0], [0]]).toBeAbout .98

  it 'can split examples on an attribute', ->
    [split1, split2] = dtl.splitExamples examples, 1
    expect(split1).toEqual [examples[0], examples[3]]

    [split1, split2] = dtl.splitExamples examples, 0
    expect(split1).toEqual [examples[0], examples[1]]

  it 'can find the information gain for an attribute', ->
    gainFunction = dtl.weightedInformationGainFunction

    result = gainFunction [[0, 1]], 0
    expect(result).toBe 0

    result = gainFunction examples, 0
    expect(result).toBe 1

    result = gainFunction examples, 1
    expect(result).toBe 0

    result = gainFunction examples, 2
    expect(result).toBeAbout .31

    result = gainFunction complexExamples, 0
    expect(result).toBeAbout .25

  it 'can find the best feature and value for a set of examples', ->
    result = dtl.findBestFeature examples
    expect(result).toEqual [0, 1]

    [feature, value] = dtl.findBestFeature complexExamples
    expect(feature).toBe 1
    expect(value).toBeAbout .46

  it 'can build a simple decision tree', ->
    result = dtl.build()
    expect(result.feature).toBe 0
    expect(result.children[0].value).toBe 0
    expect(result.children[1].value).toBe 1

  it 'can build a complex decision tree', ->
    dtl = new DecisionTreeLearner(complexExamples)
    result = dtl.build()
    expect(result.feature).toBe 1
    expect(result.children[0].feature).toBe 0
    expect(result.children[0].children[0].value).toBe 0
    expect(result.children[0].children[1].value).toBe 1
    expect(result.children[1].value).toBe 0

    dtl = new DecisionTreeLearner(moreComplexExamples)
    result = dtl.build()
    expect(result.children[0].children[0].children[1].value).toBe .5

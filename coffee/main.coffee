DecisionTreeLearner = require('../coffee/decision_tree.coffee').DecisionTreeLearner
Valuator = require('../coffee/valuator.coffee').Valuator
DatasetBuilder = require('../coffee/dataset_builder.coffee').DatasetBuilder
util = require('../coffee/util.coffee')

run = ->
  printResults()
  #printTree()

printTree = ->
  new DatasetBuilder('trainData.txt', 'trainLabel.txt').build (trainingDS) ->
    parseWords './datasets/words.txt', (words) ->
      dtl = new DecisionTreeLearner(trainingDS, 10)
      dtl.build (dt, nodes) ->
        if nodes is 10
          console.log dt.toString words

      dtl = new DecisionTreeLearner(trainingDS, 10)
      dtl.informationGainFunction = dtl.averageInformationGainFunction
      dtl.build (dt, nodes) ->
        if nodes is 10
          console.log dt.toString words

  parseWords = (path, callback) ->
    util.readFile path, (words) ->
      callback words.split '\n'

printResults = ->
  new DatasetBuilder('trainData.txt', 'trainLabel.txt').build (trainingDS) ->
    new DatasetBuilder('testData.txt', 'testLabel.txt').build (testingDS) ->
      console.log 'WEIGHTED'
      dtl = new DecisionTreeLearner(trainingDS)
      [x, y, y2] = evalDTL dtl, trainingDS, testingDS
      console.log x.join ','
      console.log y.join ','
      console.log y2.join ','

      console.log '\nAVERAGE'
      dtl = new DecisionTreeLearner(trainingDS)
      dtl.informationGainFunction = dtl.averageInformationGainFunction
      [x, y] = evalDTL dtl, trainingDS, testingDS
      console.log x.join ','
      console.log y.join ','
      console.log y2.join ','

  evalDTL = (dtl, trainingDS, testingDS) ->
    xValues = []
    yValues = []
    y2Values = []
    valuator = new Valuator testingDS
    valuatorCheck = new Valuator trainingDS

    bestAccuracy = 0
    bestSize = 0
    dtl.build (dt, size) ->
      accuracy = 1 - valuator.totalError(dt) / testingDS.length
      accuracyCheck = 1 - valuatorCheck.totalError(dt) / trainingDS.length

      if accuracy > bestAccuracy
        bestAccuracy = accuracy
        bestSize = size
      #console.log 'Tree', size, 'correct =', accuracy, accuracyCheck
      xValues.push size
      yValues.push accuracy
      y2Values.push accuracyCheck

    console.log 'Best:', bestAccuracy, 'with', bestSize, 'nodes'
    [xValues, yValues, y2Values]

run()
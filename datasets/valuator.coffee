class Valuator

  constructor: (@examples) ->

  valuate: (dt, errorFunc) ->
    error = 0
    for example in @examples
      input = example[..example.length-2]
      output = example[example.length-1]
      predicted = dt.predict input
      error += errorFunc predicted, output
    error

  MSE: (dt) ->
    @valuate dt, (predicted, output) ->
      Math.pow(output - predicted, 2)

  totalError: (dt) ->
    @valuate dt, (predicted, output) ->
      predicted = if Math.random() < predicted then 1 else 0
      return Math.abs(output - predicted)

exports.Valuator = Valuator
##
# Taken from http://rosettacode.org/wiki/Priority_queue#CoffeeScript
##
exports.PriorityQueue = ->
  # Use closure style for object creation (so no "new" required).
  # Private variables are toward top.
  h = []

  better = (a, b) ->
    h[a].priority < h[b].priority

  swap = (a, b) ->
    [h[a], h[b]] = [h[b], h[a]]

  sift_down = ->
    max = h.length
    n = 0
    while n < max
      c1 = 2*n + 1
      c2 = c1 + 1
      best = n
      best = c1 if c1 < max and better(c1, best)
      best = c2 if c2 < max and better(c2, best)
      return if best == n
      swap n, best
      n = best

  sift_up = ->
    n = h.length - 1
    while n > 0
      parent = Math.floor((n-1) / 2)
      return if better parent, n
      swap n, parent
      n = parent

  # now return the public interface, which is an object that only
  # has functions on it
  self =
    size: ->
      h.length

    push: (priority, value) ->
      elem =
        priority: priority
        value: value
      h.push elem
      sift_up()

    pop: ->
      throw Error("cannot pop from empty queue") if h.length == 0
      value = h[0].value
      last = h.pop()
      if h.length > 0
        h[0] = last
        sift_down()
      value

    peek: ->
      h[0].value
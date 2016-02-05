__author__ = 'PrithviK'

import heapq

class PriorityQueue:
  def  __init__(self):
    self.heap = []

  def push(self, item, priority):
      pair = (priority,item)
      heapq.heappush(self.heap,pair)

  def pop(self):
      (priority,item) = heapq.heappop(self.heap)
      return item

  def isEmpty(self):
    return len(self.heap) == 0


def manhattanDistance( xy1, xy2 ):
  "Returns the Manhattan distance between points xy1 and xy2"
  return abs( xy1[0] - xy2[0] ) + abs( xy1[1] - xy2[1] )

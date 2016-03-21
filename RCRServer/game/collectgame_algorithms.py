__author__ = 'kochelmj'

import random

import util


gamesetup = \
{
    'game': 'Space Collectors',
    'diff': 'Hard',
    'gridSize': 10,
    'cellData':
    {
        'wallLocations':
        [
            {
                'x': 1,
                'y': 4
            },
        ],
        'goldLocations':
        [
            {
                'x': 2,
                'y': 2
            },
        ],
        # 'gemLocations':
        # [
        #     {
        #         'x': 4,
        #         'y': 4
        #     },
        # ],
        'treasureLocations':
        [
            {
                'x': 1,
                'y': 10
            },
        ],
        'enemyStart':
        {
            'x': 5,
            'y': 6
        }
    }
}



def generateRandomItemLocations(locations, gridSize, itemDict):
    vals = locations.values()
    locs = []
    result = {}
    for k,v in itemDict.items():
        for i in xrange(v):
            loc = {'x': random.randrange(1, gridSize + 1), 'y': random.randrange(1, gridSize + 1)}
            if loc not in locs and loc not in vals:
                locs.append(loc)
                if k not in result:
                    result[k] = []
                result[k].append(loc)

    length = len(locs)

    return result

    # return {
    #     'goldLocations': locs[:length / 3],
    #     'gemLocations': locs[(length /3) + 1 : 2 * length / 3],
    #     'treasureLocations': locs[(2 * length / 3) + 1:]
    # }

def createNewSetup(gameObj):

    items = generateRandomItemLocations(gameObj.getPlayerLocations(), gameObj.gridSize, gameObj.configSettings)
    items.update({'enemyStart': {'x': 6, 'y': 5}})

    result = {
        'game': 'Space Collectors',
        'diff': 'Hard',
        'gridSize': 10,
        'cellData': items
    }

    return result

def calculateItemLocations(gameObj, locations):
    p1Loc = locations.get('p1')
    p2Loc = locations.get('p2')
    enemyLoc = locations.get('enemy')

    itemLocations = generateRandomItemLocations(locations, gameObj.gridSize, gameObj.configSettings)


    return itemLocations



def calculateEnemyMoves(gameObj, mock=True):
    localtions = gameObj.getPlayerLocations()
    if mock:
        return [
            {
                'name': 'Move',
                'params': ['S', 1]
            },
            {
                'name': 'Move',
                'params': ['E', 1]
            },
            {
                'name': 'Move',
                'params': ['N', 1]
            },
        ]



    p1Loc = locations.get('p1')
    p2Loc = locations.get('p2')
    enemyLoc = locations.get('enemy')

    enemyMoves = gameObj.maxMoves + 1
    visitedStates = set()
    frontier = util.PriorityQueue()
    currentState = (enemyLoc.get('x'), enemyLoc.get('y'))
    stateCost = 1
    hVal = collectEnemyHeuristic(p1Loc, p2Loc, currentState)
    p = hVal + stateCost
    node = (currentState, [], stateCost, hVal)
    frontier.push(node, p)
    while(1):
        if frontier.isEmpty():
            return []
        currentState, actions, stateCost, hVal = frontier.pop()
        if len(actions) == enemyMoves:
            return actions
        if currentState not in visitedStates:
            visitedStates.add(currentState)
            successors = getSuccessors(currentState)
            for successor in successors:
                nextState, nextAction, nextCost = successor
                cost = stateCost
                newActions = list(actions)
                newActions.append(nextAction)
                cost += nextCost
                newHVal = collectEnemyHeuristic(p1Loc, p2Loc, nextState)
                pVal = newHVal + cost
                newNode = (nextState, newActions, cost, newHVal)
                frontier.push(newNode, pVal)
    return []


def collectEnemyHeuristic(p1Loc, p2Loc, state):
    p1 = p1Loc['x'], p1Loc['y']
    p2 = p2Loc['x'], p2Loc['y']
    p1Dist = util.manhattanDistance(state, p1)
    p2Dist = util.manhattanDistance(state, p2)
    avg = (p1Dist - p2Dist) / 2
    return 10 - avg

def getSuccessors(state):
    successors = []
    x , y = state
    for action in [Directions.UP, Directions.DOWN, Directions.LEFT, Directions.RIGHT]:
        dx, dy = Actions.directionToVector(action)
        newX, newY = int(x + dx), int(y+dy)
        if not isWall(newX, newY):
            nextState = (newX, newY)
            cost = calculateStateCost(nextState)
            successors.append((nextState, action, cost))
    # print successors
    return successors

def calculateStateCost(state):
    return 1

def isWall(x, y):
    if x < 1 or y < 1 or x > 10 or y > 10:
        return True
    return False

class Directions:
    UP = "UpMove"
    DOWN = "DownMove"
    LEFT = "LeftMove"
    RIGHT = "RightMove"

class Actions:
    _directions = {Directions.UP: (0, 1),
                   Directions.DOWN: (0, -1),
                   Directions.RIGHT: (1, 0),
                   Directions.LEFT: (-1, 0)}
    _directionsAsList = _directions.items()

    def directionToVector(direction):
        dx, dy = Actions._directions[direction]
        return (dx, dy)
    directionToVector = staticmethod(directionToVector)


if __name__ == '__main__':
    from pprint import pprint
    locations = \
    {
        'p1': {'x': 1, 'y': 1},
        'p2': {'x': 10, 'y': 10},
        'enemy': {'x': 5, 'y': 5}
    }

    pprint(generateRandomItemLocations(locations, 10, {
        'goldLocations': 8,
        'treasureLocations': 8,
        'wallLocations': 6,
    }))


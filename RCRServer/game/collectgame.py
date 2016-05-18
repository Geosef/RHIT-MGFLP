__author__ = 'kochelmj'

import random


from game import Game

class CollectGame(Game):

    def createNewSetup(self):
        hardcodedConfig = {
            'goldLocations': 8,
            'treasureLocations': 8,
            'wallLocations': 6,
        }
        items = self.generateRandomItemLocations(self.getDefaultPlayerLocations(), self.gridSize, hardcodedConfig)
        # items.update({'enemyStart': {'x': 6, 'y': 5}})

        result = {
            'game': 'Collectors',
            'diff': 'Hard',
            'gridSize': 10,
            'cellData': items
        }

        return result

    def calculateItemLocations(self, locations):
        hardcodedConfig = {
            'goldLocations': 8,
            'treasureLocations': 8,
            'wallLocations': 6,
        }
        p1Loc = locations.get('p1')
        p2Loc = locations.get('p2')
        enemyLoc = locations.get('enemy')

        itemLocations = self.generateRandomItemLocations(locations, self.gridSize, hardcodedConfig)


        return itemLocations



    def calculateEnemyMoves(self, mock=True):
        # locations = self.getPlayerLocations()
        # if mock:
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

    def getDefaultPlayerLocations(self):
        locations = \
            {
                'p1': {'x': 1, 'y': 1},
                'p2': {'x': 10, 'y': 10},
                'enemy': {'x': 5, 'y': 5}
            }
        return locations

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


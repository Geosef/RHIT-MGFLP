__author__ = 'kochelmj'

import threading
from pprint import pprint

class Game(object):


    MAXTURNS = 10
    def __init__(self, p1Thread, gameID, packet):
        p1Thread.index = 0
        self.gameID = gameID
        self.threads = [p1Thread]
        self.lock = threading.Lock()
        self.currentTurn = 0
        self.currentMoves = {0:None, 1:None, 'lep':None}
        self.gridSize = 10
        self.full = False
        self.gameType = packet.get('gametype')
        self.difficulty = packet.get('difficulty')
        self.ready = [False, False]


    def setup(self):
        gamesetup = \
        {
            'type': 'Game Setup',
            'gametype': 'Collect',
            'gridsize': 10,
            'celldata':
            {
                'goldLocations':
                [
                    {
                        'x': 3,
                        'y': 3
                    }
                ],
                'gemLocations':
                [
                    {
                        'x': 4,
                        'y': 4
                    }
                ],
                'treasureLocations':
                [
                    {
                        'x': 6,
                        'y': 6
                    }
                ],
                'lepStart':
                {
                    'x': 5,
                    'y': 5
                }
            }
        }
        for client in self.threads:
            client.sendData(gamesetup)

        locations = \
        {
            'p1': {'x': 1, 'y': 1},
            'p2': {'x': 10, 'y': 10},
            'lep': {'x': 5, 'y': 5}
        }
        self.updateLocations(locations)

    def startGame(self, clientthread):
        with self.lock:
            self.ready[clientthread.index] = True
            if all(self.ready):
                for client in self.threads:
                    client.sendData({'type': 'Start Game'})



    def joinGame(self, p2Thread):
        self.full = True
        p2Thread.index = 1
        self.threads.append(p2Thread)
        playerJoined = \
        {
            'type': 'Player Joined',
            'username': p2Thread.userInfo.get('username')
        }
        self.threads[0].sendData(playerJoined)

    def submitMove(self, moves, thread):
        with self.lock:

            self.currentMoves[thread.index] = moves

            if self.checkFinish():
                self.finishTurn()


    def updateLocations(self, locations):
        p1Loc = locations.get('p1')
        p2Loc = locations.get('p2')
        lepLoc = locations.get('lep')

        lepMoves = self.calculateLepMoves(p1Loc, p2Loc, lepLoc)

        with self.lock:
            self.currentMoves['lep'] = lepMoves

            if self.checkFinish():
                self.finishTurn()
        for client in self.threads:
            client.sendData({'type': 'Update Locations', 'locations': {}})



    def checkFinish(self):
        '''
        checks if all players have submitted their moves
        '''
        pprint(self.currentMoves)
        return all(self.currentMoves.values())

    def finishTurn(self):
        if self.currentTurn >= self.MAXTURNS:
            self.endGame()
            return
        self.currentTurn = self.currentTurn + 1

        packet = \
        {
            'type': 'Run Events',
            'events': \
            {
                'p1': self.currentMoves[0],
                'p2': self.currentMoves[1],
                'lep': self.currentMoves['lep']
            }
        }

        for client in self.threads:
            client.sendData(packet)

        for key in self.currentMoves.keys():
            self.currentMoves[key] = None

    def endGame(self):
        packet = \
        {
            'type': 'End Game',
            'rematch': False
        }
        for client in self.threads:
            client.sendData(packet)


    def calculateLepMoves(self, p1Loc, p2Loc, lepLoc):
        return ["LeftMove", "UpMove", "RightMove", "DownMove"]

    def refuse(self):
        '''
        Host refused to play client
        :return:
        '''
        pass
        #TODO: implement kicking out peer


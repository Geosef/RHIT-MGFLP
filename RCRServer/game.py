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



    joinSuccess = \
    {
        'type': 'Join Game',
        'success': True
    }

    def setup(self):
        self.threads[1].sendData(self.joinSuccess)
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
                        'x': 2,
                        'y': 2
                    },
                    {
                        'x': 3,
                        'y': 3
                    },
                    {
                        'x': 5,
                        'y': 5
                    },
                    {
                        'x': 6,
                        'y': 6
                    },
                    {
                        'x': 8,
                        'y': 8
                    },
                    {
                        'x': 9,
                        'y': 9
                    },
                    {
                        'x': 2,
                        'y': 9
                    },
                    {
                        'x': 3,
                        'y': 8
                    },
                    {
                        'x': 5,
                        'y': 6
                    },
                    {
                        'x': 6,
                        'y': 5
                    },
                    {
                        'x': 8,
                        'y': 3
                    },
                    {
                        'x': 9,
                        'y': 2
                    },


                ],
                'gemLocations':
                [
                    {
                        'x': 4,
                        'y': 4
                    },
                    {
                        'x': 7,
                        'y': 7
                    },
                    {
                        'x': 4,
                        'y': 7
                    },
                    {
                        'x': 7,
                        'y': 4
                    },
                ],
                'treasureLocations':
                [
                    {
                        'x': 1,
                        'y': 10
                    },
                    {
                        'x': 10,
                        'y': 1
                    },
                ],
                'lepStart':
                {
                    'x': 5,
                    'y': 6
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
        lepMoves = self.calculateLepMoves(locations['p1'], locations['p2'], locations['lep'])

        with self.lock:
            self.currentMoves['lep'] = lepMoves

            if self.checkFinish():
                self.finishTurn()

    def startGame(self, clientthread):
        with self.lock:
            self.ready[clientthread.index] = True
            pprint(self.ready)
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
        for k in self.currentMoves.values():
            if k is None:
                return False
        return True

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


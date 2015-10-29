__author__ = 'kochelmj'

import threading

class Game(object):

    def __init__(self, p1Thread, gameID):
        p1Thread.index = 0
        self.gameID = gameID
        self.threads = [p1Thread]
        self.lock = threading.Lock()
        self.currentTurn = 0
        self.currentMoves = {0:None, 1:None, 'lep':None}
        self.gridSize = 10
        self.full = False


    def joinGame(self, p2Thread):
        self.full = True
        p2Thread.index = 1
        self.threads.append(p2Thread)

    def submitMove(self, moves, thread):
        with self.lock:

            self.currentMoves[thread.index] = packet.get('events')

            if self.checkFinish():
                self.finishTurn()


    def updateLocations(self, locations):
        p1Loc = locations.get('p1')
        p2Loc = locations.get('p2')
        lepLoc = locations.get('lep')

        lepMoves = calculateLepMoves(p1Loc, p2Loc, lepLoc)

        with self.lock:
            self.currentMoves['lep'] = packet.get('events')

            if self.checkFinish():
                self.finishTurn()

    def checkFinish(self):
        for v in self.currentMoves.values():
            if v is None:
                return False
        return True

    def finishTurn(self):
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

    def calculateLepMoves(self, p1Loc, p2Loc, lepLoc):
        return ["LeftMove", "UpMove", "RightMove", "DownMove"]

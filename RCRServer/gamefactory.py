__author__ = 'kochelmj'

import threading
import game

class GameFactory(object):

    MAXGAMES = 2 * 15

    def __init__(self):
        self.games = {}
        self.currentGameID = 0


    def createGame(self, client):
        gameID = self.getGameID()
        gameObject = game.Game(client, gameID)
        self.games[gameID] = gameObject
        return gameObject

    gameDictLock = threading.Lock()
    def joinGame(self, client, gameID):
        with self.gameDictLock:
            gameObject = self.games[gameID]
            if not gameObject.full:
                gameObject.joinGame(client, gameID)
                return gameObject
            else:
                return None
                #TODO: handle game join failure


    gameIDLock = threading.Lock()
    def getGameID(self):
        with self.gameIDLock:
            self.currentGameID =  (self.currentGameID + 1) % self.MAXGAMES
            return self.currentGameID
__author__ = 'kochelmj'

import threading
import game
from pprint import pprint

class GameFactory(object):

    MAXGAMES = 2 * 15

    def __init__(self):
        self.games = {}
        self.currentGameID = 0
        self.gameIDLock = threading.Lock()
        self.gameDictLock = threading.Lock()


    def createGame(self, client, packet):
        gameID = self.getGameID()
        gameObject = game.Game(client, gameID, packet)
        self.games[gameID] = gameObject
        return gameObject


    def joinGame(self, client, gameID):
        with self.gameDictLock:
            gameObject = self.games.get(gameID, None)
            if not gameObject or gameObject.full:
                return None
            #TODO: handle game join failure
            else:
                gameObject.joinGame(client)
                return gameObject


    def browseGames(self, packet):
        with self.gameDictLock:
            gameType = packet.get('gametype')
            difficulty = packet.get('difficulty')
            allGameTypes = gameType == 'all'
            allDifficulties = difficulty == 'all'

            toReturn = \
            {
                'type': 'Browse Games',
                'games': []
            }
            pprint(packet)

            for k,v in self.games.items():
                if (not v.full) and (allGameTypes or v.gameType == gameType) and (allDifficulties or v.difficulty == difficulty):
                    gameDict = \
                    {
                        'gameID': v.gameID,
                        'gametype': v.gameType,
                        'difficulty' : v.difficulty
                    }
                    toReturn.get('games').append(gameDict)
            return toReturn


    def getGameID(self):
        with self.gameIDLock:
            self.currentGameID =  (self.currentGameID + 1) % self.MAXGAMES
            return self.currentGameID
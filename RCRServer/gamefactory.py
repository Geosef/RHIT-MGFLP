__author__ = 'kochelmj'

import threading
import game
from pprint import pprint
import fakeclienthandler
import weakref

class ClientWait(object):


    def __init__(self, client_handler):
        self.client_handler = client_handler
        self.game_waits = []

    def addGameWait(self, gw):
        self.game_waits.append(weakref.ref(gw))

class GameWait(object):

    def __init__(self, client_wait, preference):
        self.client_wait = weakref.ref(client_wait)
        self.preference = preference



class GameFactory(object):

    MAXGAMES = 2 * 15

    def __init__(self):
        # self.games = {}
        self.gameWaitList = []
        self.clientWaitList = []

        self.currentGameID = 0
        self.gameIDLock = threading.Lock()
        self.gameDictLock = threading.Lock()


    # def createGame(self, client, packet):
    #     gameID = self.getGameID()
    #     gameObject = game.Game(client, gameID, packet)
    #     self.games[gameID] = gameObject
    #     return gameObject


    # def joinGame(self, client, gameID):
    #     with self.gameDictLock:
    #         gameList = self.games.values()
    #         for gameObj in gameList:
    #             if not gameObj.full:
    #                 gameObj.joinGame(client)
    #                 return gameObj
    #         # gameObject = self.games.get(gameID, None)
    #
    #         # if not gameObject or gameObject.full:
    #         client.sendData({
    #         'type': 'Join Game',
    #         'success': False
    #     })
    #         return None
    #         #TODO: handle game join failure
    #         # else:
    #         #     gameObject.joinGame(client)
    #         #     return gameObject




    def removeWaiter(self, clientWaitObj):
        #remove all things from both lists
        self.clientWaitList.remove(clientWaitObj)
        for d in clientWaitObj.game_waits:
            self.gameWaitList.remove(d())

    def createGame(self, host, client, preference):
        #send host joined
        #send client joining
        hostPacket = {'type': 'Player Joined', 'game': preference}
        host.sendData(hostPacket)
        clientPacket = {'type': 'Browse Games', 'match': True, 'game': preference}
        client.sendData(clientPacket)

        gameID = self.getGameID()
        gameObject = game.Game(host, client, gameID, preference)
        host.setGame(gameObject)
        client.setGame(gameObject)
        # return gameObject


    def joinGame(self, client, choices, hostWaitObj, gameWaitObj):
        if gameWaitObj.preference is not None:
            preference = gameWaitObj.preference
        elif len(choices) > 0:
            pass
            # pick of the choices
        else:
            pass
            #pick random

        host = hostWaitObj.client_handler
        self.createGame(host, client, preference)

        #4 situations, really 3

    def waitForMatch(self, client, choices):
        clientWait = ClientWait(client)
        # clientWait['client_handler'] = client
        # gameWaits = []
        if len(choices) == 0:
            gameWait = GameWait(clientWait, None)
            clientWait.addGameWait(gameWait)
            self.gameWaitList.append(gameWait)
            # gameWait = {}
            # gameWait['preference'] = None
            # gameWait['client_wait'] = weakref.proxy(clientWait)
            # gameWaits.append(weakref.proxy(gameWait))
        else:
            for choice in choices:
                gameWait = GameWait(clientWait, choice)
                clientWait.addGameWait(gameWait)
                self.gameWaitList.append(gameWait)
                # gameWait = {}
                # gameWait['preference'] = choice
                # gameWait['client_wait'] = weakref.proxy(clientWait)
                # gameWaits.append(weakref.proxy(gameWait))
        self.clientWaitList.append(clientWait)



    def browseGames(self, client, packet):
        choices = packet.get('choices')
        noPrefs = len(choices) == 0
        match = False
        with self.gameDictLock:
            for gameWaitObj in self.gameWaitList:
                if noPrefs or (gameWaitObj.preference in choices):
                    match = True
                    # hostWaitDict = gameWaitDict.get('client_wait')
                    hostWaitObj = gameWaitObj.client_wait()
                    self.removeWaiter(hostWaitObj)
            if not match:
                return self.waitForMatch(client, choices)

        return self.joinGame(client, choices, hostWaitObj, gameWaitObj)
            # with self.gameDictLock:
            #     gameType = packet.get('gametype')
            #     difficulty = packet.get('difficulty')
            #     allGameTypes = gameType == 'all'
            #     allDifficulties = difficulty == 'all'
            #
            #     toReturn = \
            #     {
            #         'type': 'Browse Games',
            #         'games': []
            #     }
            #     # pprint(packet)
            #
            #     for k,v in self.games.items():
            #         if (not v.full) and (allGameTypes or v.gameType == gameType) and (allDifficulties or v.difficulty == difficulty):
            #             gameDict = \
            #             {
            #                 'gameID': v.gameID,
            #                 'gametype': v.gameType,
            #                 'difficulty' : v.difficulty
            #             }
            #             toReturn.get('games').append(gameDict)
            #     return toReturn


    def getGameID(self):
        with self.gameIDLock:
            self.currentGameID =  (self.currentGameID + 1) % self.MAXGAMES
            return self.currentGameID

if __name__ == '__main__':
    ch1 = fakeclienthandler.FakeClientThread()
    ch2 = fakeclienthandler.FakeClientThread()
    gf = GameFactory()
    browsePacket = {'type': 'Browse Games', 'choices': [
        {
            'gametype': 'Space Collectors',
            'difficulty': 'Hard'
        }
    ]}
    gf.browseGames(ch1, browsePacket.copy())
    gf.browseGames(ch2, browsePacket.copy())
    pass
    #make fakesocket
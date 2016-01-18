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
        self.gameWaitList = []
        self.clientWaitList = []

        self.currentGameID = 0
        self.gameIDLock = threading.Lock()
        self.gameWaitListLock = threading.Lock()

    def removeWaiterHandler(self, clientHandler):
        for waiter in self.clientWaitList:
            if clientHandler is waiter.client_handler:
                return self.removeWaiter(waiter)

    def removeWaiter(self, clientWaitObj):
        #remove all things from both lists
        self.clientWaitList.remove(clientWaitObj)
        for d in clientWaitObj.game_waits:
            self.gameWaitList.remove(d())

    def createGame(self, host, client, preference):
        #send host "client joined"
        #send client "joining game"
        hostPacket = {'type': 'Player Joined', 'game': preference}
        host.sendData(hostPacket)
        clientPacket = {'type': 'Browse Games', 'match': True, 'game': preference}
        client.sendData(clientPacket)

        gameID = self.getGameID()
        gameObject = game.Game(host, client, gameID, preference)
        host.setGame(gameObject)
        client.setGame(gameObject)


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

    def waitForMatch(self, client, choices):
        packet = {}
        packet['type'] = 'Browse Games'
        packet['match'] = False
        client.sendData(packet)
        clientWait = ClientWait(client)
        if len(choices) == 0:
            gameWait = GameWait(clientWait, None)
            clientWait.addGameWait(gameWait)
            self.gameWaitList.append(gameWait)
        else:
            for choice in choices:
                gameWait = GameWait(clientWait, choice)
                clientWait.addGameWait(gameWait)
                self.gameWaitList.append(gameWait)
        self.clientWaitList.append(clientWait)



    def browseGames(self, client, packet):
        choices = packet.get('choices')
        noPrefs = len(choices) == 0
        match = False
        with self.gameWaitListLock:
            for gameWaitObj in self.gameWaitList:
                if noPrefs or (gameWaitObj.preference in choices):
                    match = True
                    # hostWaitDict = gameWaitDict.get('client_wait')
                    hostWaitObj = gameWaitObj.client_wait()
                    self.removeWaiter(hostWaitObj)
            if not match:
                return self.waitForMatch(client, choices)

        return self.joinGame(client, choices, hostWaitObj, gameWaitObj)


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
    # gf.removeWaiterHandler(ch1)
    gf.browseGames(ch2, browsePacket.copy())
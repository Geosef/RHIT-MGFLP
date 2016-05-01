__author__ = 'kochelmj'

import threading
import weakref
import random

import game
from tests import fakeclienthandler, fakesocket
from user import clienthandler as ch


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

    def __init__(self, gf_config):
        self.gametypes = gf_config.get('gametypes')
        self.difficulties = gf_config.get('difficulties')
        self.gameWaitList = []
        self.clientWaitList = []

        self.currentGameID = 0
        self.gameIDLock = threading.Lock()
        self.gameWaitListLock = threading.Lock()


    def removeWaiterHandler(self, clientHandler):
        #called from client handler so we need the thread lock
        waiterFound = False
        with self.gameWaitListLock:
            waiter = next((temp for temp in self.clientWaitList if clientHandler is temp.client_handler), None)
            if waiter:
                self.removeWaiter(waiter)
                waiterFound = True
        return waiterFound

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
            preference = random.choice(foo)
        else:
            preference = random.choice(self.allGameTypes)

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


    def checkValid(self, choices):
        totalMax = len(self.gametypes) + len(self.difficulties)
        if len(choices) > totalMax:
            return False

        for choice in choices:
            if choice.get('game') not in self.gametypes \
            or choice.get('diff') not in self.difficulties:
                return False

        return True


    def browseGames(self, client, packet):
        print str(packet)
        choices = packet.get('choices')
        valid_request = self.checkValid(choices)
        if not valid_request:
            return
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
                self.waitForMatch(client, choices)
        if match:
            self.joinGame(client, choices, hostWaitObj, gameWaitObj)
        else:
            pass
            # self.joinGame(client, choices, self.hw, self.gw)
            # ch = fakeclienthandler.FakeClientThread()
            # self.browseGames(ch, {'choices': [{'game': 'Space Collectors', 'diff': 'Hard'}]})


    def getGameID(self):
        with self.gameIDLock:
            self.currentGameID =  (self.currentGameID + 1) % self.MAXGAMES
            return self.currentGameID

    allGameTypes = [
        {'game': 'Space Collectors', 'diff': 'Easy'},
        {'game': 'Space Collectors', 'diff': 'Medium'},
        {'game': 'Space Collectors', 'diff': 'Hard'},
        {'game': 'Zombie Survivors', 'diff': 'Easy'},
        {'game': 'Zombie Survivors', 'diff': 'Medium'},
        {'game': 'Zombie Survivors', 'diff': 'Hard'},
        {'game': 'Game 3', 'diff': 'Easy'},
        {'game': 'Game 3', 'diff': 'Medium'},
        {'game': 'Game 3', 'diff': 'Hard'}
    ]

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
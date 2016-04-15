__author__ = 'kochelmj'

import json
import logging
import threading
import time
from pprint import pprint

import user

uf = user.UserFactory()

class ClientThread(threading.Thread):

    def __init__(self, sock, game_factory):
        super(ClientThread, self).__init__(target=self.handle)
        self.sock = sock
        self.game_factory = game_factory
        self.loggedIn = False
        self.user_factory = uf

        self.methodRoutes = \
        {
            'Login': self.login,
            'Create Account': self.createAccount,
            'Create Game': self.createGame,
            'Join Game': self.joinGame,
            'Submit Move': self.submitMove,
            'Update Locations': self.updateLocations,
            'End Game': self.endGame,
            'Quit': self.quit,
            'Browse Games': self.browseGames,
            'Player Joined': self.playerJoined,
            'Start Game': self.startGame,
            'Cancel Search': self.cancelSearch
        }


    def loginLoop(self):
        while True:
            try:
                jsonstring = self.sock.recv(1024)
                data = json.loads(jsonstring)
            except Exception as e:
                print(str(e))
                break

            methodType = data.get('type', None)
            if not methodType:
                pprint(data)
                print('Invalid Client Data')
                continue

            method = self.methodRoutes.get(methodType, None)
            if method:
                if methodType == 'Login':
                    user = method(data)
                    if user:
                        self.setLoggedIn(user)
                        break
                elif methodType == 'Create Account':
                    method(data)
            else:
                pprint(data)
                print('Invalid Client Data')
                continue

    def login(self, packet, **kw):

        credentials = {
            'email': packet.get('email'),
            'password': packet.get('password')
        }

        user = self.user_factory.login(credentials)

        if user:
            success = True
        else:
            success = False
            user = None

        data = \
        {
            'type': 'Login',
            'success': success
        }
        self.loggedIn = success
        if not kw.get('no_data'):
            self.sendData(data)

        return user

    def setLoggedIn(self, user):
        self.user = user
        self.afterLogin()


    def afterLogin(self):
        while True:
            try:
                jsonstring = self.sock.recv(1024)
                data = json.loads(jsonstring)
            except Exception as e:
                print(str(e))
                break

            methodType = data.get('type', None)
            if not methodType:
                pprint(data)
                print('Invalid Client Data')
                continue

            method = self.methodRoutes.get(methodType, None)
            if method and methodType not in ['Login', 'Create Account']:
                method(data)
            else:
                pprint(data)
                print('Invalid Client Data')
                continue

    def handle(self):
        self.loginLoop()
        try:
            self.game_factory.removeWaiterHandler(self)
            self.sock.close()
            logging.info('Client Disconnected')
            print 'Client Disconnected'
        except Exception as e:
            pass

    def receiveData(self):
        try:
            jsonstring = self.sock.recv(1024)
        except Exception as e:
            self.quit()
        data = json.loads(jsonstring)


    def sendData(self, data):
        try:
            # print 'Sending', data['type']
            self.sock.send(json.dumps(data) + "\n")
        except Exception as e:

            print('error sendData')
            print(str(e))
            time.sleep(3)
            pprint(data)
            #TODO: handle json error
            #TODO: if socket is gone, clean up thread and game


    def quit(self, packet):
        self.game.quit(self)
        # pprint(packet)

    def endGame(self, packet):
        pass
        # self.game.rematch(self, packet)
        # pprint(packet)

    def submitMove(self, packet):
        moves = packet.get('moves')
        self.game.submitMove(moves, self)
        # pprint(packet)

    def updateLocations(self, packet):
        locations = packet.get('locations')
        scores = packet.get('scores')
        self.game.updateLocations(locations, scores)
        # pprint(packet)


    def removeGame(self):
        self.setGame(None)


    def createAccount(self, packet):
        validParams = set(packet.keys()) == set(['type', 'username', 'email', 'password'])
        if validParams:
            user_obj = self.user_factory.createAccount(packet)
            success = True if user_obj else False
        toSend = {
            'type': 'Create Account',
            'success': success
        }
        # if success:
        #     self.login(packet, no_data=True)
        self.sendData(toSend)


    def browseGames(self, packet):
        self.game_factory.browseGames(self, packet)
        # game factory takes care of responses


    def playerJoined(self, packet):
        pass
        # if packet.get('accept'):
        #     self.game.setup(True)
        # else:
        #     self.game.refuse()

    def startGame(self, packet):
        self.game.startGame(self)

    def setGame(self, game):
        self.game = game

    def cancelSearch(self, packet):
        success = self.game_factory.removeWaiterHandler(self)
        if success:
            toSend = {
                'type': 'Cancel Search',
                'success': True
            }
            self.sendData(toSend)



    #-------------------------------------------------------------------------------#
    #   DEPRECATED FUNCTIONS                                                        #
    #-------------------------------------------------------------------------------#


    def joinGame(self, packet):
        gameID = packet.get('gameID')
        self.game = self.game_factory.joinGame(self, gameID)

        # pprint(packet)

    def createGame(self, packet):
        # pprint(packet)
        self.game = self.game_factory.createGame(self, packet)
        data = \
        {
            'type': 'Create Game',
	        'success': True,
	        'gameID': self.game.gameID
        }
        self.sendData(data)
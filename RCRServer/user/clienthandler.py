__author__ = 'kochelmj'

import json, threading
from pprint import pprint
import logging
import time
import login
import createaccount

class ClientThread(threading.Thread):

    def __init__(self, sock, gameFactory):
        super(ClientThread, self).__init__(target=self.handle)
        self.sock = sock
        self.gameFactory = gameFactory
        self.loggedIn = False
        self.userInfo = {}

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
            'Start Game': self.startGame
        }

    def handle(self):
        while True:
            try:
                jsonstring = self.sock.recv(1024)
                data = json.loads(jsonstring)
            except Exception as e:
                print(str(e))
                break
            if data.get('type') != 'Browse Games':
                if hasattr(self, 'index'):
                    pass
                    # print(data.get('type'), str(self.index))
                else:
                    pass
                    # print(data.get('type'))

            methodType = data.get('type', None)
            if not methodType:
                pprint(data)
                print('Invalid Client Data')
                continue

            method = self.methodRoutes.get(methodType, None)
            if method:
                if self.loggedIn:
                    method(data)
                else:
                    if methodType in ['Login', 'Create Account']:
                        method(data)
            else:
                pprint(data)
                print('Invalid Client Data')
                continue
        try:
            self.sock.close()
            logging.info('Client Disconnected')
            print 'Client Disconnected'
            self.gameFactory.removeWaiterHandler(self)
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

    def joinGame(self, packet):
        gameID = packet.get('gameID')
        self.game = self.gameFactory.joinGame(self, gameID)

        # pprint(packet)

    def createGame(self, packet):
        # pprint(packet)
        self.game = self.gameFactory.createGame(self, packet)
        data = \
        {
            'type': 'Create Game',
	        'success': True,
	        'gameID': self.game.gameID
        }
        self.sendData(data)

    def removeGame(self):
        self.setGame(None)

    def login(self, packet, **kw):
        #TODO: make user identified by email in JSON
        email = packet.get('email')
        password = packet.get('password')

        # success = login.validLogin(email, password)
        success = True

        if success:
            playerID = 1
            self.userInfo['playerID'] = playerID
            self.userInfo['username'] = packet.get('email')


        data = \
        {
            'type': 'Login',
            'success': success
        }
        self.loggedIn = success
        if not kw.get('no_data'):
            self.sendData(data)

    def createAccount(self, packet):
        validParams = packet.get('email') and packet.get('password')
        if validParams:
            success = createaccount.createAccount(packet.get('email'), packet.get('password'))
        toSend = {
            'type': 'Create Account',
            'success': success
        }
        if success:
            self.login(packet, no_data=True)
        self.sendData(toSend)



    def browseGames(self, packet):
        self.gameFactory.browseGames(self, packet)
        # game factory takes care of responses

        # self.sendData(games)
        # pprint(games)

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

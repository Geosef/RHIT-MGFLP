__author__ = 'kochelmj'

import json, threading
from pprint import pprint


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
                    if methodType == 'Login':
                        method(data)
            else:
                pprint(data)
                print('Invalid Client Data')
                continue
        try:
            self.sock.close()
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
            print(str(e))
            #TODO: handle json error
            #TODO: if socket is gone, clean up thread and game


    def quit(self, packet):
        self.game.quit(self)
        # pprint(packet)

    def endGame(self, packet):
        self.game.rematch(self, packet)
        # pprint(packet)

    def submitMove(self, packet):
        moves = packet.get('events')
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

    DEFAULT_USER = 'user'
    DEFAULT_PASSWORD = 'password'
    def login(self, packet):
        playerID = 1
        self.userInfo['username'] = packet.get('username')
        self.userInfo['playerID'] = playerID
        print 'Logging in user:', self.userInfo.get('username')
        success = packet.get('username') == self.DEFAULT_USER and packet.get('password') == self.DEFAULT_PASSWORD
        data = \
        {
            'type': 'Login',
            'success': success,
            'playerID': playerID
        }
        self.loggedIn = True
        self.sendData(data)

    def browseGames(self, packet):
        self.gameFactory.browseGames(self, packet)
        # game factory takes care of responses

        # self.sendData(games)
        # pprint(games)

    def playerJoined(self, packet):
        if packet.get('accept'):
            self.game.setup(True)
        else:
            self.game.refuse()

    def startGame(self, packet):
        self.game.startGame(self)

    def setGame(self, game):
        self.game = game
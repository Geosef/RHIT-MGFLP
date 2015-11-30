__author__ = 'kochelmj'

import threading
import json
import time
from pprint import pprint

class FakeSocket(object):
    '''
    If host is true:
    create a game
    else:
    browse for games until one is available, join it
    '''

    login = \
    {
        'type': 'Login',
        'username': 'user',
        'password': 'pass'
    }

    def __init__(self, host):
        self.host = host
        self.lock = threading.Lock()
        self.packet = {}
        self.packet = self.login
        self.userInfo = {'username': 'fake', 'playerID': 0}

    def send(self, jsondata):
        data = json.loads(jsondata)
        recvpacket = self.preparerecv(data)
        with self.lock:
            time.sleep(0.1)
            self.packet = recvpacket

    def recv(self, buffersize):
        '''
        Get packet prepared by send()
        :param size:
        :return:
        '''
        while True:
            with self.lock:
                if self.packet:
                    # print 'recv'
                    localpacket = self.packet
                    # if self.host and self.packet.get('type') == 'Run'
                    self.packet = {}
                    return json.dumps(localpacket)

    submitmove = \
    {
        'type': 'Submit Move',
        'events': ['UpMove', 'LeftMove', 'DownMove', 'RightMove']
    }

    updatelocations = \
    {
        'type': 'Update Locations',
        'locations':
        {
            'p1':
            {
                'x': 1,
                'y': 1
            },
            'p2':
            {
                'x': 5,
                'y': 5
            },
            'lep':
            {
                'x': 3,
                'y': 3
            }
        },
        'scores':
        [10, 10]
    }
    startgame = \
    {
        'type': 'Start Game'
    }
    creategame = \
    {
        'type': 'Create Game',
        'gametype': 'Collect',
        'difficulty': 'Easy'
    }
    browsegames = \
    {
        'type': 'Browse Games',
        'gametype': 'Collect',
        'difficulty': 'Easy'
    }

    def preparerecv(self, data):
        type = data.get('type', '')
        if type == 'Game Over':
            return {'type': 'End Game', 'rematch': True}
        if type == 'Update Locations':
            print 'UPDATE LOC'
            return self.submitmove
        if type == 'Login':
            if self.host:
                return self.creategame
            else:
                return self.browsegames
        if type == 'Create Game':
            return {}
        if type == 'Player Joined':
            return {'type': 'Player Joined', 'accept': True}
        if type == 'Join Game':
            if not data.get('success'):
                return self.browsegames
            else:
                return {}
        if type == 'Browse Games':
            games = data.get('games')
            if len(games) == 0:
                return self.browsegames
            else:
                game = games[0]
                return {'type': 'Join Game', 'gameID': game.get('gameID')}
        if type == 'Game Setup':
            # pprint(data)
            self.gridsize = data.get('gridSize')
            return self.startgame
        if type == 'Start Game':
            print 'START GAME'
            return self.submitmove
        if type == 'Run Events':
            print 'RUN EVENTS'
            if self.host:
                print 'RETURNING UPDATELOCATIONS'
                return self.updatelocations
            return {}
        if type == 'End Game':
            pprint(data)
            return {}
        print 'OTHER TYPE: ', type
        return {}
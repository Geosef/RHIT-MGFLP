__author__ = 'kochelmj'

import threading
import json
import time
from pprint import pprint

class FakeSocket(object):

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
        'gameID': 1,
        'events': ['MoveUp', 'MoveLeft', 'MoveDown', 'MoveRight']
    }

    receivefuncs = \
    {
        'Update Location': ''
    }

    updatelocations = \
    {
        'type': 'Update Locations',
        'locations': \
        {
            'p1': \
            {
                'x': 1,
                'y': 1
            },
            'p2': \
            {
                'x': 5,
                'y': 5
            },
            'lep': \
            {
                'x': 3,
                'y': 3
            }
        }
    }
    startgame = \
    {
        'type': 'Start Game',
        'gameID': 1
    }
    creategame = \
    {
        'type': 'Create Game',
        'gametype': 'Collect',
        'difficulty': 1
    }
    browsegames = \
    {
        'type': 'Browse Games',
        'gametype': 'Collect',
        'difficulty': 1
    }

    def preparerecv(self, data):
        type = data.get('type', '')
        if type == 'Update Locations':
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
        if type == 'Browse Games':
            games = data.get('games')
            if len(games) == 0:
                return self.browsegames
            else:
                game = games[0]
                return {'type': 'Join Game', 'gameID': game.get('gameID')}
        if type == 'Game Setup':
            pprint(data)
            self.gridsize = data.get('gridSize')
            return self.startgame
        if type == 'Start Game':
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
        return {}
__author__ = 'kochelmj'

import threading
import json
import time
from pprint import pprint

class FakeSocket(object):

    login = \
    {
        'type': 'Login',
        'email': 'test3',
        'password': 'test3'
    }

    def __init__(self, host, numRematches = 2):
        self.host = host
        self.lock = threading.Lock()
        self.packet = {}
        self.packet = self.login
        self.userInfo = {'username': 'fake', 'playerID': 0}
        self.numRematches = numRematches
        self.events = []

    def send(self, jsondata):
        data = json.loads(jsondata)
        recvpacket = self.preparerecv(data)
        # data['source'] = 'send'
        self.log(data)
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
                    toReturn = json.dumps(localpacket)
                    # localpacket['source'] = 'recv'
                    self.log(localpacket)
                    if localpacket.get('type') == 'Submit Move':
                        time.sleep(3.0)
                    return toReturn

    submitmove = \
    {
        'type': 'Submit Move',
        'moves': [{
            'name': 'Move',
			'params':
			[
				"S",
				1
			]
        }]
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
            'enemy':
            {
                'x': 3,
                'y': 3
            }
        },
        'scores':
        [10, 11]
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
        'choices': [
            {
                'game': 'Collectors',
                'diff': 'Hard'
            }
        ]
    }

    def preparerecv(self, data):
        type = data.get('type', '')
        if type == 'Game Over':
            if self.numRematches:
                self.numRematches -= 1
                return {'type': 'End Game', 'rematch': True}
            else:
                return {'type': 'End Game', 'rematch': False}
        if type == 'Update Locations':
            # print 'UPDATE LOC'
            return self.submitmove
        if type == 'Login':
            return self.browsegames
                # return self.browsegames
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
            match = data.get('match')

            # if len(games) == 0:
            #     time.sleep(1)
            #     return self.browsegames
            # else:
            #     game = games[0]
            #     return {'type': 'Join Game', 'gameID': game.get('gameID')}
        if type == 'Game Setup':
            # pprint(data)
            self.gridsize = data.get('gridSize')
            self.host = data.get('host')
            return self.submitmove
            # return self.startgame
        if type == 'Start Game':
            # print 'START GAME'
            return self.submitmove
        if type == 'Run Events':
            # print 'RUN EVENTS'
            if self.host:
                # print 'RETURNING UPDATELOCATIONS'
                return self.updatelocations
            else:
                return self.submitmove
        if type == 'End Game':
            # pprint(data)
            return {}
        if type == 'Rematch':
            pass

        print 'OTHER TYPE: ', type
        return {}

    def log(self, packet):
        toLog = {'type': packet['type'], 'source': 'null'} #packet['source']}
        pprint(packet)
        self.events.append(toLog)

    def getEvents(self):
        return self.events



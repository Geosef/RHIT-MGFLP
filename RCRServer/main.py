__author__ = 'kochelmj'


import socket, threading
import pprint
import json
from user import clienthandler
from game import gamefactory
from tests import fakesocket
import logging
from appconfig import configapp, confignetwork

import signal
import sys


def main():

    # gameFactory = gamefactory.GameFactory()

    gameFactory = configapp.config()

    host, port = confignetwork.config()



    loggingConfig = {
        'filename': 'logs/server.log',
        'level': logging.INFO,
        'format': '%(asctime)s %(message)s',
        'datefmt': '%Y-%m-%d %I:%M:%S'
    }
    logging.basicConfig(**loggingConfig)
    logging.info('Server Started')

    def startListening():
        port = 5005

        tcpsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        tcpsock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

        tcpsock.bind((host,port))
        print('server created')
        print 'Host: ' + host
        print 'Port: ' + str(port)


        index = 0
        try:
            while True:
                tcpsock.listen(4)
                print 'Listening'
                logging.info('Listening')
                (clientsock, (ip, port)) = tcpsock.accept()
                print 'client {0} connected'.format(str(index))
                logging.info('client {0} connected'.format(str(index)))
                t = clienthandler.ClientThread(clientsock, gameFactory)
                t.start()
                index += 1
        except Exception as e:
            print str(e)
            logging.error(str(e))
            try:
                tcpsock.close()
                print 'Socket Closed'
            except:
                pass
        def signal_handler(signal, frame):
            try:
                tcpsock.close()
                print 'Socket Closed'
            except:
                pass
            sys.exit(0)
        signal.signal(signal.SIGINT, signal_handler)

    startListening()

if __name__ == "__main__":
    main()

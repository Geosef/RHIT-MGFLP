__author__ = 'kochelmj'

import logging
import signal
import socket
import sys

from game import gamefactory
from tests import fakesocket
from user import clienthandler


def main():

    gameFactory = gamefactory.GameFactory()

    # host = 'localhost'
    host = '137.112.226.24'
    # host = '192.168.5.107'
    # host = '54.201.206.189'
    # host = '0.0.0.0'


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

        peerSocket1 = fakesocket.FakeSocket(True)

        peerHandler1 = clienthandler.ClientThread(peerSocket1, gameFactory)
        # peerHandler1.start()

        peerSocket2 = fakesocket.FakeSocket(False)

        peerHandler2 = clienthandler.ClientThread(peerSocket2, gameFactory)
        # peerHandler2.start()

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

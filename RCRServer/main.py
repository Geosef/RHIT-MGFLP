__author__ = 'kochelmj'


import socket, threading
import pprint
import json
import clienthandler
import gamefactory
import fakesocket

def main():

    gameFactory = gamefactory.GameFactory()

    # host = 'localhost'
    # host = '192.168.254.21'
    host = '137.112.233.136'
    port = 5005

    tcpsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    tcpsock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    tcpsock.bind((host,port))
    print('server created')
    print 'Host: ' + host
    print 'Port: ' + str(port)

    peerSocket1 = fakesocket.FakeSocket(False)

    peerHandler1 = clienthandler.ClientThread(peerSocket1, gameFactory)
    peerHandler1.start()

    peerSocket2 = fakesocket.FakeSocket(False)

    peerHandler2 = clienthandler.ClientThread(peerSocket2, gameFactory)
    peerHandler2.start()

    index = 0
    while True:
        tcpsock.listen(4)
        print 'Listening'
        (clientsock, (ip, port)) = tcpsock.accept()
        print 'client {0} connected'.format(str(index))
        t = clienthandler.ClientThread(clientsock, gameFactory)
        t.start()
        index += 1

if __name__ == "__main__":
    main()
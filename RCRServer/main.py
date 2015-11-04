__author__ = 'kochelmj'


import socket, threading
import pprint
import json
import clienthandler
import gamefactory

def main():

    gameFactory = gamefactory.GameFactory()

    # host = 'localhost'
    # host = '192.168.254.21'
    host = '192.168.254.21'
    port = 5005

    tcpsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    tcpsock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    tcpsock.bind((host,port))
    print('server created')
    print 'Host: ' + host
    print 'Port: ' + str(port)


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
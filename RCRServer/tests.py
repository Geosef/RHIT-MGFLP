__author__ = 'kochelmj'

import fakesocket
import gamefactory
import clienthandler



if __name__ == '__main__':
    hostSocket = fakesocket.FakeSocket(True)
    peerSocket = fakesocket.FakeSocket(False)

    gameFactory = gamefactory.GameFactory()

    hostHandler = clienthandler.ClientThread(hostSocket, gameFactory)
    peerHandler = clienthandler.ClientThread(peerSocket, gameFactory)

    hostHandler.start()
    peerHandler.start()

__author__ = 'kochelmj'

import fakesocket
import gamefactory
import clienthandler
from pprint import pprint
import time
import unittest
import testutility

# assertDictEqual(d1, d2):


class ServerOnlyTests(unittest.TestCase):

    def testOneRematchEach(self):
        hostSocket = fakesocket.FakeSocket(True, 1)
        peerSocket = fakesocket.FakeSocket(False, 1)

        gameFactory = gamefactory.GameFactory()

        hostHandler = clienthandler.ClientThread(hostSocket, gameFactory)
        peerHandler = clienthandler.ClientThread(peerSocket, gameFactory)

        hostHandler.start()
        time.sleep(1)
        peerHandler.start()

        time.sleep(7)

        hostEvents = hostSocket.getEvents()
        peerEvents = peerSocket.getEvents()

        self.assertEqual(testutility.testOneRematchEach_HostExpected, hostEvents)
        self.assertEqual(testutility.testOneRematchEach_PeerExpected, peerEvents)

# -----------------------------------------------------------------------------------------------------------------

    def testOneRematchHost(self):
        hostSocket = fakesocket.FakeSocket(True, 1)
        peerSocket = fakesocket.FakeSocket(False, 0)

        gameFactory = gamefactory.GameFactory()

        hostHandler = clienthandler.ClientThread(hostSocket, gameFactory)
        peerHandler = clienthandler.ClientThread(peerSocket, gameFactory)

        hostHandler.start()
        time.sleep(1)
        peerHandler.start()

        time.sleep(7)

        hostEvents = hostSocket.getEvents()
        peerEvents = peerSocket.getEvents()

        self.assertEqual(testutility.testOneRematchHost_HostExpected, hostEvents)
        self.assertEqual(testutility.testOneRematchHost_PeerExpected, peerEvents)

# -----------------------------------------------------------------------------------------------------------------

    def testOneRematchPeer(self):
        hostSocket = fakesocket.FakeSocket(True, 0)
        peerSocket = fakesocket.FakeSocket(False, 1)

        gameFactory = gamefactory.GameFactory()

        hostHandler = clienthandler.ClientThread(hostSocket, gameFactory)
        peerHandler = clienthandler.ClientThread(peerSocket, gameFactory)

        hostHandler.start()
        time.sleep(1)
        peerHandler.start()

        time.sleep(7)

        hostEvents = hostSocket.getEvents()
        peerEvents = peerSocket.getEvents()

        self.assertEqual(testutility.testOneRematchPeer_HostExpected, hostEvents)
        self.assertEqual(testutility.testOneRematchPeer_PeerExpected, peerEvents)


if __name__ == '__main__':
    unittest.main()



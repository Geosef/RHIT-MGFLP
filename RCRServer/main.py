__author__ = 'kochelmj'


import socket, threading
import pprint
import json

receivedbool = [False, False]
receivedevents = [[], []]
lock = threading.Lock()

class ClientThread(threading.Thread):

    def handle(self):
        global receivedbool
        global receivedevents
        jsonstring = self.sock.recv(1024)
        data = json.loads(jsonstring)
        pprint.pprint(data)
        initinfo = {'playerIndex': self.index}
        self.sendData(initinfo)
        while True:
            jsonstring = self.sock.recv(1024)
            data = json.loads(jsonstring)
            pprint.pprint(data)
            tosend = {'valid': True}
            self.sock.send(json.dumps(tosend) + "\n")
            events = data.get('events')
            lock.acquire()
            receivedbool[self.index] = True
            receivedevents[self.index].extend(events)
            if receivedbool[0] and receivedbool[1]:
                print 'received both'

                eventstosend = {'p1': receivedevents[0],
                      'p2': receivedevents[1]}
                for thread in clientthreads:
                    thread.sendData(eventstosend)

                receivedbool = [False, False]
                receivedevents = [[], []]

            else:
                print 'not received yet'
                print str(receivedbool)
                pass


            lock.release()

    def sendData(self, data):
        self.sock.send(json.dumps(data) + "\n")


    def __init__(self, sock, index):
        super(ClientThread, self).__init__(target=self.handle)
        self.sock = sock
        self.index = index
        print(self.index)


# host = 'localhost'
host = '192.168.254.21'
port = 5005




tcpsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
tcpsock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

tcpsock.bind((host,port))
print('server created')
print 'Host: ' + host
print 'Port: ' + str(port)

clientthreads = []


index = 0
while True:
    tcpsock.listen(4)
    print 'Listening'
    (clientsock, (ip, port)) = tcpsock.accept()
    print 'client {0} connected'.format(str(index))
    t = ClientThread(clientsock, index)
    clientthreads.append(t)
    t.start()
    index += 1
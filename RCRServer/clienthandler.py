__author__ = 'kochelmj'

import json, threading
import pprint

receivedbools = []
receivedevents = []
lock = threading.Lock()

clientthreads = []


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
            try:
                jsonstring = self.sock.recv(1024)
            except:
                self.sock = None
            data = json.loads(jsonstring)
            pprint.pprint(data)
            tosend = {'valid': True}
            self.sock.send(json.dumps(tosend) + "\n")
            events = data.get('events')
            lock.acquire()
            receivedbools[self.index // 2][self.index % 2] = True
            receivedevents[self.index // 2][self.index % 2].extend(events)
            if receivedbools[self.index // 2][0] and receivedbools[self.index // 2][1]:
                print 'received both'

                eventstosend = {'p1': receivedevents[self.index // 2][0],
                      'p2': receivedevents[self.index // 2][1]}

                index = self.index
                if index % 2 == 1:
                    index = index - 1

                clientthreads[index].sendData(eventstosend)
                clientthreads[index + 1].sendData(eventstosend)

                receivedbools[self.index // 2] = [False, False]
                receivedevents[self.index // 2] = [[], []]

            else:
                print 'not received yet'
                print str(receivedbools[self.index // 2])
                pass


            lock.release()

    def sendData(self, data):
        if self.sock is not None:
            self.sock.send(json.dumps(data) + "\n")


    def __init__(self, sock, index):
        super(ClientThread, self).__init__(target=self.handle)
        self.sock = sock
        self.index = index
        print(self.index)
        if index %2 == 0:
            receivedbools.append([False, False])
            receivedevents.append([[], []])
        clientthreads.append(self)

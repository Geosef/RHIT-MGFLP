from user import clienthandler as ch
import json
from tests import fakesocket


def config(gamefactory=None):
    with open('appconfig/config.json') as fp:
        jsonstr = fp.read()
        conf = json.loads(jsonstr)
    if conf.get('fake_client'):
        if gamefactory:
            fakech = ch.ClientThread(fakesocket.FakeSocket(False), gamefactory)
            fakech.start()

    host = conf.get('host')
    return host
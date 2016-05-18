from user import clienthandler as ch
import json
from tests import fakesocket
from game import gamefactory as gf


def config():
    with open('appconfig/config.json') as fp:
        jsonstr = fp.read()
        conf = json.loads(jsonstr)
    if conf:
        if conf.get('gamefactory_config'):
            game_factory = gf.GameFactory(conf.get('gamefactory_config'), conf.get('fake_client'))
            if conf.get('fake_client') and conf.get('fake_client').get('active') and conf.get('fake_client').get('host'):
                fakech = ch.ClientThread(fakesocket.FakeSocket(False, conf.get('fake_client')), game_factory)
                fakech.start()
            return game_factory
    else:
        return None
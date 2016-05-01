import json

def config():
    with open('appconfig/networkconfig.json') as fp:
        jsonstr = fp.read()
        conf = json.loads(jsonstr)
    if conf:
        return conf.get('host'), conf.get('port')
    else:
        return '', 5005
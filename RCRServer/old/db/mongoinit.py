from pymongo.mongo_client import MongoClient
import logging
import humongolus as mongodb
import datetime
import humongolus.field as field
import hashlib

conn = MongoClient()
FORMAT = '%(asctime)-15s %(message)s'
logging.basicConfig(format=FORMAT)
logger = logging.getLogger("humongolus")

mongodb.settings(logger=logger, db_connection=conn)

class LoginInfo(mongodb.EmbeddedDocument):
    email = field.Char(min=0, max=30)
    password = field.Char(min=0, max=30)

class UserStats(mongodb.EmbeddedDocument):
    total_wins = field.Integer(min=0, max=10000000, default=0)
    total_games = field.Integer(min=0, max=10000000, default=0)
    total_loops = field.Integer(min=0, max=10000000, default=0)


class User(mongodb.Document):
    _db = "rcr"
    _collection = "users"
    user_id = field.AutoIncrement(collection="users")
    username = field.Char(required=True, min=2, max=25)
    login_info = LoginInfo()
    user_stats = UserStats()

    def sysout(self):
        print self._json()

class UserFactory(object):

    def __init__(self):
        pass


    def createAccount(self, user):
        '''
        :param user: dict {username, email, password}
        :return: User object, or None if already exists
        '''
        if self.login(user): #user exists already
            return None

        new_user = User()
        new_user.username = user.get('username')

        logininfo = LoginInfo()
        logininfo.email = user.get('email')
        logininfo.password = self.hashPassword(user.get('password'))

        userstats = UserStats()

        new_user.login_info = logininfo
        new_user.user_stats = userstats

        # new_user.sysout()

        try:
            _id = new_user.save()
        except Exception as e:
            print str(e)
            return None

        return new_user

    def hashPassword(self, password):
        m = hashlib.sha256()
        m.update(password)
        return m.hexdigest()
        # return password

    def login(self, credentials):
        query = {'login_info.email': credentials.get('email')}
        userdoc = User.find_one(query)
        if userdoc:
            hashed = self.hashPassword(credentials.get('password'))
            if userdoc.login_info.password == hashed:
                return userdoc
            else:
                return None
        else:
            return None


if __name__ == '__main__':
    cred = {'username': 'me2', 'email': 'hello@example.com', 'password': 'password1'}

    temp = UserFactory().createAccount(cred)
    if temp:
        temp.sysout()
    else:
        print 'already exists'

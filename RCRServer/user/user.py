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


#-------------------------------------------------------------------------------------#
#                       ---- LOGIN INFO ----                                          #
#-------------------------------------------------------------------------------------#

class LoginInfo(mongodb.EmbeddedDocument):
    email = field.Char(min=0, max=50)
    password = field.Char(min=0, max=64)

    # not the reserved init function
    def init(self, userDict=None):
        self.email = userDict.get('email')
        self.password = self.hashPassword(userDict.get('password'))

    def login(self, credentials):
        hashed = self.hashPassword(credentials.get('password'))
        success = True if self.password == hashed else False
        return success

    def hashPassword(self, password):
        m = hashlib.sha256()
        m.update(password)
        return m.hexdigest()
        # return password


#-------------------------------------------------------------------------------------#
#                       ---- USER STATS ----                                          #
#-------------------------------------------------------------------------------------#

class UserStats(mongodb.EmbeddedDocument):
    total_wins = field.Integer(min=0, max=10000000, default=0)
    total_games = field.Integer(min=0, max=10000000, default=0)
    total_loops = field.Integer(min=0, max=10000000, default=0)


#-------------------------------------------------------------------------------------#
#                       ---- USER OBJECT ----                                         #
#                      LoginInfo and UserStats                                        #
#-------------------------------------------------------------------------------------#


class User(mongodb.Document):
    _db = "rcr"
    _collection = "users"
    user_id = field.AutoIncrement(collection="users")
    username = field.Char(required=True, min=2, max=25)
    login_info = LoginInfo()
    user_stats = UserStats()

    # not the reserved init function
    def init(self, userDict=None):
        self.username = userDict.get('username')
        self.login_info = LoginInfo()
        self.login_info.init(userDict)
        self.user_stats = UserStats()


    def sysout(self):
        print self._json()

class UserFactory(object):


    def createAccount(self, user):
        '''
        :param user: dict {username, email, password}
        :return: User object, or None if already exists
        '''
        if self.login(user): #user exists already
            return None

        new_user = User()
        new_user.init(user)
        
        try:
            _id = new_user.save()
        except Exception as e:
            print str(e)
            return None

        return new_user
    

    def login(self, credentials, bool=False):
        query = {'login_info.email': credentials.get('email')}
        userdoc = User.find_one(query)

        if userdoc:
            success = userdoc.login_info.login(credentials)            
            if bool:
                return success
            elif success:
                return userdoc
            else:
                return None


if __name__ == '__main__':
    cred = {'username': 'test4', 'email': 'test4', 'password': 'test4'}
    
    temp = UserFactory().createAccount(cred)
    if temp:
        temp.sysout()
    else:
        print 'already exists'
    

    temp = User.find({})
    for k in temp:
        k.sysout()



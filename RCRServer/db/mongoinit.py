from pymongo.mongo_client import MongoClient
import logging
import humongolus as mongodb
import datetime
import humongolus.field as field

conn = MongoClient()
FORMAT = '%(asctime)-15s %(message)s'
logging.basicConfig(format=FORMAT)
logger = logging.getLogger("humongolus")

mongodb.settings(logger=logger, db_connection=conn)

class LoginInfo(mongodb.EmbeddedDocument):
  email = field.Char(min=0, max=3000)
  password = field.Char(min=0, max=3000)

class UserStats(mongodb.EmbeddedDocument):
  total_wins = field.Integer(min=0, max=3000)
  total_games = field.Integer(min=0, max=3000)
  total_loops = field.Integer(min=0, max=3000)


class User(mongodb.Document):
  _db = "rcr"
  _collection = "users"
  user_id = field.AutoIncrement(collection="users")
  username = field.Char(required=True, min=2, max=25)
  login_info = LoginInfo()
  user_stats = UserStats()




if __name__ == '__main__':
    user = User()
    user.username = "user"

    logininfo = LoginInfo()
    logininfo.email = 'hello1'
    logininfo.password = 'password2'

    userstats = UserStats()
    userstats.total_wins = 50
    userstats.total_plays = 100
    userstats.total_loops = 500

    user.login_info = logininfo
    user.user_stats = userstats


    print user._json()

    _id = user.save()
    print _id

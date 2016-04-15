import json
from pprint import pprint
import logging

with open('db/database.json') as data_file:
    db = json.load(data_file)

def validLogin(email, password):
    log_string = 'Checking login validity of email: ' + str(email) + ' password: ' + str(password)
    logging.info(log_string)
    success = db.get(email) and db.get(email).get('password') == password
    if success:
        print('Logged in email: ' + str(email) + ' password: ' + str(password))
        logging.info('Logged in email: ' + str(email) + ' password: ' + str(password))
    else:
        print('Login failed email: ' + str(email) + ' password: ' + str(password))
        logging.info('Login failed email: ' + str(email) + ' password: ' + str(password))
    return success == True


if __name__ == '__main__':
    print(validLogin('user', 'password'))
    print(validLogin('user1', 'password'))
    print(validLogin('user', 'password1'))

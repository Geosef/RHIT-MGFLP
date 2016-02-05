import json
from pprint import pprint
import logging



def createAccount(email, password):
    '''
    :param email:
    :param password:
    :return: success
    '''
    log_string = 'Checking create account validity of email: ' + str(email) + ' password: ' + str(password)
    logging.info(log_string)
    exists = db.get(email)
    if exists:
        logging.info('Account with email already exists: ' + str(email))
        return False

    logging.info('Creating Account email: ' + str(email) + ' password: ' + str(password))

    with open('db/database.json') as data_file:
        db = json.load(data_file)
        db.put(email, {'email': email, 'password': password})
    with open('db/database.json') as fp:
        json.dump(db, fp)

    return True



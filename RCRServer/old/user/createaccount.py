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

    logging.info('Creating Account email: ' + str(email) + ' password: ' + str(password))
    print 'Creating Account email: ' + str(email) + ' password: ' + str(password)

    with open('db/database.json') as data_file:
        db = json.load(data_file)
        exists = db.get(email)
        if exists:
            logging.info('Account with email already exists: ' + str(email))
            print 'exists'
            return False
        else:
            print 'does not exist'
            db[email] = {'email': email, 'password': password}
    with open('db/database.json', 'w') as fp:
        json.dump(db, fp, indent=4)

    return True



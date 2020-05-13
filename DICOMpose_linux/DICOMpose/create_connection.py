"""
Created Winter 2020
@author: sb3784 / clover612

create_connection.py creates a database connection to dicompose database file
"""



import sqlite3
from sqlite3 import Error
import sys
 
 
def create_connection(db_file):
    """ create a database connection to a SQLite database """
    conn = None
    try:
        conn = sqlite3.connect(db_file)
        print(sqlite3.version)
    except Error as e:
        print(e)
    finally:
        if conn:
            conn.close()
 
 
if __name__ == '__main__':
    db_file=sys.argv[1]
    create_connection(db_file)
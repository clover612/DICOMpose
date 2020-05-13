"""
Created Winter 2020
@author: sb3784/clover612

sqlNewCD.py checks if CD/file location has or hasn't been entered
into dicompose database file
"""

import sqlite3
from sqlite3 import Error
import sys
import numpy as np
 
def create_connection(db_file):
    """ create a database connection to the SQLite database
        specified by db_file
    :param db_file: database file
    :return: Connection object or None
    """
    conn = None
    try:
        conn = sqlite3.connect(db_file)
    except Error as e:
        print(e)
 
    return conn

def check_cdid(conn, newCD):
    """
    Query CDId in the PatientImages table
    :param conn: the Connection object
    :return:
    """
    cur = conn.cursor()

    cur.execute("SELECT CDId FROM PatientImages")
 
    CDs = cur.fetchall()

    uniq_CDs=np.unique(CDs)
 
    if newCD in uniq_CDs:
        print("0")
    else:
        print("1")

def main():
    database = sys.argv[1];
 
    # create a database connection
    conn = create_connection(database)
    with conn:
        check_cdid(conn,sys.argv[2])
 
 
if __name__ == '__main__':
    main()
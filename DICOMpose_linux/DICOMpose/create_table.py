import sqlite3
from sqlite3 import Error
import sys
 
 
def create_connection(db_file):
    """ create a database connection to the SQLite database
        specified by db_file
    :param db_file: database file
    :return: Connection object or None
    """
    conn = None
    try:
        conn = sqlite3.connect(db_file)
        return conn
    except Error as e:
        print(e)
 
    return conn
 
 
def create_table(conn, create_table_sql):
    """ create a table from the create_table_sql statement
    :param conn: Connection object
    :param create_table_sql: a CREATE TABLE statement
    :return:
    """
    try:
        c = conn.cursor()
        c.execute(create_table_sql)
    except Error as e:
        print(e)
 
 
def main():
    database = sys.argv[1];
 
    sql_create_PatientImages_table = """ CREATE TABLE IF NOT EXISTS PatientImages ( 
                                    PatientId          Varchar(50)         NOT NULL,
                                    ImageAcqDate       Decimal(14,0)       NOT NULL,
                                    CDId               Varchar(20)         NOT NULL,
                                    ProtocolName       Varchar(100)        NOT NULL,
                                    ImageName          Varchar(510)        NOT NULL,
                                    ImageLocation      Varchar(1000)       NOT NULL,
                                    SummaryImage       BLOB,
                                    VoxelXDim          Decimal(10,6), 
                                    VoxelYDim          Decimal(10,6), 
                                    VoxelZDim          Decimal(10,6), 
                                    ImageXDim          Integer,
                                    ImageYDim          Integer,
                                    ImageZDim          Integer,
                                    FOVXDim            Decimal(10,6),
                                    FOVYDim            Decimal(10,6),
                                    FOVZDim            Decimal(10,6),
                                    CreateUserId       Varchar(50)         NOT NULL,
                                    CreateDateTime     Varchar(50)         NOT NULL,
                                    ModifyUserId       Varchar(50)         NOT NULL,
                                    ModifyDateTime     Varchar(50)         NOT NULL
                                );"""
 
    # create a database connection
    conn = create_connection(database)
 
    # create tables
    if conn is not None:
        # create projects table
        create_table(conn, sql_create_PatientImages_table)
    else:
        print("Error! cannot create the database connection.")
 
 
if __name__ == '__main__':
    main()
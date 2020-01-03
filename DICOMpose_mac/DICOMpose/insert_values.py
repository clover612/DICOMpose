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
    except Error as e:
        print(e)
 
    return conn
 
 
def create_PatientImage(conn, PatientImage):
    """
    Create a new PatientImage into the PatientImages table
    :param conn:
    :param PatientImage:
    :return: PatientImage id
    """
    sql = ''' INSERT INTO PatientImages(PatientId,ImageAcqDate,CDId,ProtocolName,ImageName,ImageLocation,SummaryImage,VoxelXDim,VoxelYDim,VoxelZDim,ImageXDim,ImageYDim,ImageZDim,FOVXDim,FOVYDim,FOVZDim,CreateUserId,CreateDateTime,ModifyUserId,ModifyDateTime)
              VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) '''
    cur = conn.cursor()
    cur.execute(sql, PatientImage)
    return cur.lastrowid
 
def convertToBinaryData(filename):
    # Convert digital data to binary format
    with open(filename, 'rb') as file:
        binaryData = file.read()
    return binaryData
 
 
def main():
    database = sys.argv[1];
 
    # create a database connection
    conn = create_connection(database)
    with conn:
        # create a new PatientImage
        summimg_raw=convertToBinaryData(sys.argv[8]); 
        PatientImage = (sys.argv[2], sys.argv[3],sys.argv[4], sys.argv[5], sys.argv[6],sys.argv[7], summimg_raw, sys.argv[9], sys.argv[10], sys.argv[11], sys.argv[12],sys.argv[13], sys.argv[14], sys.argv[15],sys.argv[16], sys.argv[17], sys.argv[18], sys.argv[19], sys.argv[20], sys.argv[21]);
        PatientImage_id = create_PatientImage(conn, PatientImage)
 
 
if __name__ == '__main__':
    main()
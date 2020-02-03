import sys, glob, os
import base64

def inplace_change(filename,filenametmp,old_string,img):
    with open(img, "rb") as image_file:
         new_string = base64.b64encode(image_file.read())
    f1 = open(filename, 'r')
    f2 = open(filenametmp, 'w') 
    for line in f1:
        f2.write(line.replace(old_string,new_string))
    f1.close()
    f2.close()

def main():
    filename=sys.argv[1]
    filenametmp=sys.argv[2]
    old_string=sys.argv[3]
    new_string=sys.argv[4]
    inplace_change(filename,filenametmp,old_string, new_string)

if __name__=='__main__':
    main()
